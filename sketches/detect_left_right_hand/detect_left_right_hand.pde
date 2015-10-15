PrintWriter output;

import SimpleOpenNI.*; 
SimpleOpenNI kinect;

void setup() { 
size(640, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
kinect.setMirror(true);
// turn on user tracking 
kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
output = createWriter("positions.txt");
}

int timesRun = 0;
int maxDistance = 0;
int currentDistance = 0;

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

// convert the detected hand position // to "projective" coordinates // that will match the depth image 
PVector convertedRightHand = new PVector(); 
PVector convertedRightElbow = new PVector(); 
PVector convertedRightShoulder = new PVector(); 
PVector convertedLeftShoulder = new PVector(); 
PVector convertedLeftHand = new PVector(); 

kinect.convertRealWorldToProjective(rightHand, convertedRightHand); 
kinect.convertRealWorldToProjective(rightElbow, convertedRightElbow); 
kinect.convertRealWorldToProjective(rightShoulder, convertedRightShoulder); 
kinect.convertRealWorldToProjective(leftShoulder, convertedLeftShoulder); 
kinect.convertRealWorldToProjective(leftHand, convertedLeftHand); 
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

//println(convertedRightElbow.y-convertedRightHand.y);
currentDistance = int( convertedRightElbow.y-convertedRightHand.y );
println("times: " + timesRun + " distance: "+ currentDistance);

if(timesRun==0)
{
  maxDistance = int( convertedRightElbow.y - convertedRightHand.y );
}
else
{
  println(map(currentDistance,maxDistance,-maxDistance,180,60));
  output.println(map(currentDistance,maxDistance,-maxDistance,180,60));
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
maxDistance = currentDistance;
println(maxDistance);
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

void stop() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
} 
