import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;

LeapMotionP5 leap;

public void setup() {
  size(500, 500);
  leap = new LeapMotionP5(this);
}

public void draw() {
  background(0);
  fill(255);
  
  // STORE FINGERS Z
  // THE SIZE IS 20 JUST IN CASE WE HAVE ANY FALSE POSITIVES
  float[] fingersArray = new float[20]; 
  // NUMBER OF FINGERS
  int fingers = 0;
    
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    
    // ADD FINGER Z TO ARRAY
    fingersArray[fingers] = fingerPos.z;
    
    ellipse(fingerPos.x, fingerPos.y, 10, 10);
    
    // FINGER RECOGNISED
    fingers++;
  }
  
  //println("number of fingers: " + fingers);
  String zees = ""; 
  for(int i = 0; i<fingers; i++ )
  {
    zees += "finger No."+fingers+" - z: "+fingersArray[i]+" | ";
    
  }
  println(zees);
}

public void stop() {
  leap.stop();
}

