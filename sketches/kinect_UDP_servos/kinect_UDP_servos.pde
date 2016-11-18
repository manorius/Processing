// Daniel Shiffman
// Kinect Point Cloud example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
// import UDP library
import hypermedia.net.*;


UDP udp;  // define the UDP object

// Kinect Library object
Kinect kinect;

// Angle for rotation
float a = 0;
float r = 0;
    String ip1      = "10.1.20.67";  // RIGHT the remote IP address
    String ip2      = "10.1.20.66";  // LEFT the remote IP address
    int port        = 8888;    // the destination port
    int averD = 0; // Average depth of central points
    int noOfAver = 0; // Number to calculate average
    int far = 960;
    int near = 650;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setup() {
  // Rendering in P3D
  size(800, 600, P3D);
  kinect = new Kinect(this);
  kinect.initDepth();

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
    // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

void draw() {

  background(255);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 10;

  // Translate and rotate
  translate(width/2, height/2, -50);
 // rotateY(a);
///camera(mouseX, height/2, (height/2) / tan(PI/6), mouseX, height/2, 0, 0, 1, 0);
  //translate(width/2, height/2, -100);
 // r+=800-mouseX;
 // rotateY(r);
 //int rD = 0;
 //println(kinect.width+" - "+kinect.height);
 
 int xAreaLength = 50;
 int yAreaLength = xAreaLength;
 
 int xAreaStart = round(((kinect.width/skip)*0.5)*skip)-round(xAreaLength*0.5);
 int xAreaEnd   = xAreaStart+xAreaLength;
 
  int yAreaStart = round(((kinect.height/skip)*0.5)*skip)-round(yAreaLength*0.5);
 int yAreaEnd   = yAreaStart+yAreaLength;
 
// println(xAreaStart+" -x- "+xAreaEnd);
// println(yAreaStart+" -y- "+yAreaEnd);
 
  for (int x = 0; x < kinect.width; x += skip) {
    for (int y = 0; y < kinect.height; y += skip) {
      int offset = x + y*kinect.width;
int rD;
      // Convert kinect data to world xyz coordinate
      int rawDepth = rD = depth[offset];
      PVector v = depthToWorld(x, y, rawDepth);
      
      float rDc = map(rD, 200, 900, 0, 255);
      if(x>=xAreaStart && x<=xAreaEnd && y>=yAreaStart && y<=yAreaEnd && rD!= 2047)
      {
        averD+=rD;
        noOfAver++;
      stroke(0,255,0);
   
      }
      else stroke(rDc,0,0);
      strokeWeight(5);
      pushMatrix();
      translate(v.x*factor, v.y*factor, factor-v.z*factor);
      // Draw a point
      point(0, 0);
      popMatrix();
    }
   
  }
// SEND SIGNAL
if(averD>0){
int averageDepth = averD/noOfAver;
println(averageDepth);
String message1 = constrain(round(map( averageDepth,near,far,0,180)),0,180)+"";
String message2 = constrain(round(map( averageDepth,near,far,180,0)),0,180)+"";
udp.send( message1, ip1, port );
udp.send( message2, ip2, port );
println(message1+ "  " +message2);
}

// RESET VALUES
averD=0;
noOfAver=0;


  // Rotate
  a += 0.015f;
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

      // Scale up by 200
      float factor = 200;
      
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  println(e);
  factor+=e;
  if(factor>500)
  {
   factor=500; 
  }
  else if(factor<50)
  {
   factor = 50; 
  }
}
PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}
