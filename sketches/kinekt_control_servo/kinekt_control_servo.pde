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

  println(Serial.list()); // List COM-ports

  //select second com-port from the list
  port = new Serial(this, Serial.list()[0], 115200); 
  
port.bufferUntil('\n');
}

int timesRun = 0;
int maxHandDistance = 0;
int currentHandDistance = 0;

int maxShoulderDistance = 0;
int currentShoulderDistance = 0;

void draw() { 
kinect.update(); 
PImage depth = kinect.depthImage(); 

tint(255, 10);  // Apply transparency without changing color
image(depth, 0, 0);
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
ellipse(convertedRightShoulder.x, convertedRightShoulder.y, 10, 10);
fill(0,255,255);
ellipse(convertedLeftShoulder.x, convertedLeftShoulder.y, 10, 10);
fill(0,255,0);
ellipse(convertedLeftHand.x, convertedLeftHand.y, 10, 10);
fill(102,255,51);
ellipse(convertedNeck.x, convertedNeck.y, 10, 10);

//println(convertedRightElbow.y-convertedRightHand.y);
currentHandDistance = int( convertedRightElbow.y-convertedRightHand.y );
currentShoulderDistance = int( convertedRightShoulder.y-convertedRightShoulder.y );
//println("times: " + timesRun + " distance: "+ currentHandDistance);

if(timesRun==0)
{
  maxHandDistance = int( convertedRightElbow.y - convertedRightHand.y );
  maxShoulderDistance = int( convertedRightShoulder.x - convertedLeftShoulder.x );
}
else
{
  int servoPos1 = int(map(currentHandDistance,maxHandDistance,-maxHandDistance,180,60));
  int servoPos2 = int(map(currentShoulderDistance,maxShoulderDistance,0,180,0));
  println(maxShoulderDistance);
  //output.println(servoPos1);
  moveServo(servoPos1, servoPos2);
}
timesRun++;
}}}


// user-tracking callbacks! 
void onNewUser(int userId) {
println("start pose detection"); 
kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) { 
if (successful) {
maxHandDistance = currentHandDistance;
println(maxHandDistance);
println(" User calibrated !!!"); 
kinect.startTrackingSkeleton(userId);
} else { 
println(" Failed to calibrate user !!!"); 
kinect.startPoseDetection("Psi", userId);
}
}
void onStartPose(String pose, int userId) { 
println("Started pose for user"); 
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


void moveServo(int _armServoVal, int _headServoVal) 
{
 
  // CHECKING IF THE SERVO POSITION IS INBETWEEN THE ALLOWED LIMITS
  armServoVal = (_armServoVal<180 && _armServoVal>60)? _armServoVal:armServoVal;
  headServoVal = (_headServoVal<180 && _headServoVal>60)? _headServoVal:headServoVal;
  
 // SEND THE VALUES
  port.write(HEADER); 
  port.write(MOUSE); 
  port.write(armServoVal); 
  port.write(headServoVal);  
}

void keyPressed() {
  if (key==ESC) {
    key=0;
    output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
    exit();
  }
}

