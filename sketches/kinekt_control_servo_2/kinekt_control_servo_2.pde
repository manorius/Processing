PrintWriter output;

import SimpleOpenNI.*; 
import processing.serial.*;  
SimpleOpenNI kinect;
Serial port;                         // The serial port
public static final char HEADER = '|';
public static final char MOUSE = 'M';

void setup() { 
size(640, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
kinect.setMirror(true);
// turn on user tracking 
kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
output = createWriter("positions.txt");
frameRate(100);

  //println(Serial.list()); // List COM-ports

  //select second com-port from the list
  port = new Serial(this, Serial.list()[0], 115200); 
  
port.bufferUntil('\n');
}

int timesRun = 0;
int maxHandDistance = 0;
int currentHandDistance = 0;

int maxShoulderDistance = 0;
int currentShoulderDistance = 0;

int lSSize = 10;
int rSSize = 10;

int lNeckMaxDistance = 0;
int rNeckMaxDistance = 0;

int lNeckCurrentDistance = 0;
int rNeckCurrentDistance = 0;

String frontShoulder = "";
boolean lightsToggle = false;
boolean switchArea = false;
boolean isInside = false;

void draw() { 
kinect.update(); 
PImage depth = kinect.depthImage(); 

tint(255, 10);  // Apply transparency without changing color
image(depth, 0, 0);

// ADD RECTANGULAR AREA
fill(0,255,0);
rect(50, 350, 50, 50);

// make a vector of ints to store the list of users 
IntVector userList = new IntVector();
// write the list of detected users // into our vector 
kinect.getUsers(userList);
// if we found any users 
if (userList.size() > 0) {

// get the first user 
int userId = userList.get(0);
// if we’re successfully calibrated 
if ( kinect.isTrackingSkeleton(userId)) { 
// make a vector to store the left hand

PVector rightHand = new PVector(); 
PVector rightElbow = new PVector();
PVector rightShoulder = new PVector();
PVector leftShoulder = new PVector();
PVector leftHand = new PVector(); 
PVector neck = new PVector(); 

// put the position of the left hand into that 
float rightConfidence = kinect.getJointPositionSkeleton(userId,
SimpleOpenNI.SKEL_RIGHT_HAND, 
rightHand);

float rightEConfidence = kinect.getJointPositionSkeleton(userId,
SimpleOpenNI.SKEL_RIGHT_ELBOW, 
rightElbow);

float rightSConfidence = kinect.getJointPositionSkeleton(userId,
SimpleOpenNI.SKEL_RIGHT_SHOULDER, 
rightShoulder);

float leftSConfidence = kinect.getJointPositionSkeleton(userId,
SimpleOpenNI.SKEL_LEFT_SHOULDER, 
leftShoulder);

float leftConfidence = kinect.getJointPositionSkeleton(userId,
SimpleOpenNI.SKEL_LEFT_HAND, 
leftHand);

float neckConfidence = kinect.getJointPositionSkeleton(userId,
SimpleOpenNI.SKEL_NECK, 
neck);

// convert the detected hand position // to "projective" coordinates // that will match the depth image 
PVector convertedRightHand = new PVector(); 
PVector convertedRightElbow = new PVector(); 
PVector convertedRightShoulder = new PVector(); 
PVector convertedLeftShoulder = new PVector(); 
PVector convertedLeftHand = new PVector(); 
PVector convertedNeck = new PVector(); 

kinect.convertRealWorldToProjective(rightHand, convertedRightHand); 
kinect.convertRealWorldToProjective(rightElbow, convertedRightElbow); 
kinect.convertRealWorldToProjective(rightShoulder, convertedRightShoulder); 
kinect.convertRealWorldToProjective(leftShoulder, convertedLeftShoulder); 
kinect.convertRealWorldToProjective(leftHand, convertedLeftHand); 
kinect.convertRealWorldToProjective(neck, convertedNeck); 
// and display it

fill(255,0,0); 
ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
fill(0,0,255); 
ellipse(convertedRightElbow.x, convertedRightElbow.y, 10, 10);
fill(0,255,255);
ellipse(convertedRightShoulder.x, convertedRightShoulder.y, rSSize, rSSize);
fill(0,255,255);
ellipse(convertedLeftShoulder.x, convertedLeftShoulder.y, lSSize, lSSize);
fill(0,255,0);
ellipse(convertedLeftHand.x, convertedLeftHand.y, 10, 10);
fill(102,255,51);
ellipse(convertedNeck.x, convertedNeck.y, 10, 10);

////println(convertedRightElbow.y-convertedRightHand.y);
currentHandDistance = int( convertedRightElbow.y-convertedRightHand.y );
currentShoulderDistance = int( convertedRightShoulder.y-convertedRightShoulder.y );
////println("times: " + timesRun + " distance: "+ currentHandDistance);

int servoPos1;
int servoPos2;

// CONFIGURING THE RIGHT ARM AND NECK DISTANCE
if(timesRun==0)
{
  // FIND OUT THE MAX HAND DISTANCE
  maxHandDistance = int( convertedRightElbow.y - convertedRightHand.y );
  maxShoulderDistance = int( convertedRightShoulder.x - convertedLeftShoulder.x );
  
  // CONFIGURING THE SHOULDERS
  lNeckMaxDistance = int( convertedNeck.x - convertedLeftShoulder.x );
  rNeckMaxDistance = int( convertedRightShoulder.x - convertedNeck.x );
  //println(lNeckMaxDistance+" ------  "+rNeckMaxDistance);
  
}
else
{
  servoPos1 = int(map(currentHandDistance,maxHandDistance,-maxHandDistance,180,60));
  //int servoPos2 = int(map(currentShoulderDistance,maxShoulderDistance,0,180,0));
  ////println(maxShoulderDistance);
  //output.//println(servoPos1);
  
  // DETECT WHICH SHOULDER IS IN FRONT
frontShoulder = (convertedLeftShoulder.z - convertedRightShoulder.z > 0)? "l":"r";
// IF LEFT SHOULDER IS IN FRONTIT MEANS THAT WE ARE TURNING LEFT
if(frontShoulder == "l")
{
 lSSize = 10;
 rSSize = 30;
 int lNeckCurrentDistance = int(convertedNeck.x - convertedLeftShoulder.x);
 servoPos2 = int(map(lNeckCurrentDistance,lNeckMaxDistance,lNeckMaxDistance*0.5,120,0));
 ////println("LEFT: "+servoPos2);
}
// ELSE WE ARE TURNING RIGHT
else           
{
 rSSize = 10;
 lSSize = 30;
 int rNeckCurrentDistance = int( convertedRightShoulder.x -  convertedNeck.x);
 servoPos2 =int(map(rNeckCurrentDistance,rNeckMaxDistance,rNeckMaxDistance*0.5,120,180));
 //println("RIGHT: "+servoPos2);

}

//50, 350, 50, 50
int leftHandX = int(convertedLeftHand.x);
int leftHandY = int(convertedLeftHand.y);

if( leftHandX>50 && leftHandX<105 && leftHandY>350 && leftHandY<455 && isInside==false)
{
  isInside = true;
  lightsToggle = (lightsToggle == false)? true:false;
  println("inside");
}
else if((leftHandX<50 || leftHandX>105 || leftHandY<350 || leftHandY>455) && isInside==true)
{
  isInside = false; 
  println("outside");
}


println(switchArea+"  AND LIGHT ARE: "+lightsToggle);
 
////println(abs(convertedLeftHand.x-convertedLeftHand.y));
moveServo(servoPos1, servoPos2);

////println(convertedLeftShoulder.z+"  -  "+convertedRightShoulder.z);


}
timesRun++;
}}}


// user-tracking callbacks! 
void onNewUser(int userId) {
//println("start pose detection"); 
kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) { 
if (successful) {
//println(" User calibrated !!!"); 
kinect.startTrackingSkeleton(userId);
} else { 
//println(" Failed to calibrate user !!!"); 
kinect.startPoseDetection("Psi", userId);
}
}
void onStartPose(String pose, int userId) { 
//println("Started pose for user"); 
kinect.stopPoseDetection(userId); 
kinect.requestCalibrationSkeleton(userId, true);
}

void serialEvent(Serial myPort)
{
  // handle incoming serial data
String inString = port.readStringUntil('\n');
if(inString != null) {
 //println( inString );  // echo text string from Arduino 
}

}

int armServoVal  = 180;
int headServoVal = 180;
int leftEye = 0;
int rightEye = 0;


void moveServo(int _armServoVal, int _headServoVal) 
{
 
  // CHECKING IF THE SERVO POSITION IS INBETWEEN THE ALLOWED LIMITS
  armServoVal = (_armServoVal<180 && _armServoVal>60)? _armServoVal:armServoVal;
  headServoVal = (_headServoVal<180 && _headServoVal>0)? _headServoVal:headServoVal;
  
  if(lightsToggle == true)
  {
    leftEye = 1;
    rightEye = 1;
    //println("1");
  }
  else
  {
  leftEye = 0;
    rightEye = 0;
    //println("0");
  }
  
 // SEND THE VALUES
  port.write(HEADER); 
  port.write(MOUSE); 
  port.write(armServoVal); 
  port.write(headServoVal);  
  port.write(leftEye); 
  port.write(rightEye); 
}

void keyPressed() {
  if (key==ESC) {
    key=0;
    output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
    exit();
  }
}

