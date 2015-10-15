import de.voidplus.leapmotion.*;
import processing.serial.*;
import controlP5.*;
import java.awt.event.KeyEvent;
import simplify.*;

LeapMotion leap;
PGraphics pg;
Serial myPort;
PVector[] points = new PVector[0];
boolean motionPlanned=false;
ControlP5 cp5;

String textValue = "";

void setup(){
  size(800, 500);
  pg = createGraphics(800, 500);
  pg.beginDraw();
  pg.endDraw();
  background(255);
  noStroke(); fill(50);
  // ...
    
  leap = new LeapMotion(this);
  
  // COMMUNICATION TO THE PRINTER AND UI
  
  PFont font = createFont("helvetica neue",20);
  
  // SETTING INPUT FIELD
  
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("input")
     .setPosition(20,70)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,255))
     .setCaptionLabel("")
     ;
  
  // SETTING BUTTONS
  cp5.addBang("SEND")
     .setPosition(240,70)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
  
    // KILL ALL
  cp5.addBang("KILLALL")
     .setPosition(240,10)
     .setSize(80,40)
     .setCaptionLabel("KILL ALL")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;  
   
   cp5.addBang("SIMPLIFY")
     .setPosition(240,130)
     .setSize(80,40)
     .setCaptionLabel("simplify")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
  
  //initialize the serial port to talk to the printer
  println(Serial.list());
  myPort=new Serial(this, Serial.list()[2], 250000);
   myPort.write("G21\r\n");
   
   textFont(font);
}

void draw(){
  // PAINTING THE BACKGROUND
  background(255);
  
  // ADD THE GRAPHICS BUFFER
  image(pg, 0, 0);
  
  // UPDATE INPUT FIELD
  updateText(textHistory);
  
  // ...
  int fps = leap.getFrameRate();
  
  // STORE FINGERS Z
  // THE SIZE IS 20 JUST IN CASE WE HAVE ANY FALSE POSITIVES
  PVector[] fingersArray = new PVector[20]; 
  float[]   fingersZ     = new float[20];
  // NUMBER OF FINGERS
  int fingers = 0;
    
  // HANDS
  for(Hand hand : leap.getHands()){

    //hand.draw(30);
    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();
    
    // FINGERS
    for(Finger finger : hand.getFingers()){
      
      // Basics
      //finger.draw(50);
      int     finger_id         = finger.getId();
      PVector finger_position   = finger.getPosition();
      PVector finger_stabilized = finger.getStabilizedPosition();
      PVector finger_velocity   = finger.getVelocity();
      PVector finger_direction  = finger.getDirection();
      float   finger_time       = finger.getTimeVisible();
      
      // Touch Emulation
      int     touch_zone        = finger.getTouchZone();
      float   touch_distance    = finger.getTouchDistance();
      
      // ADD FINGERS COORDINATES TO ARRAY
      fingersArray[fingers] = finger_position;
      // ADD Z POSITION TO ARRAY
      fingersZ[fingers]     = finger_position.z;
      // FINGER RECOGNISED
      fingers++;
      
      switch(touch_zone){
        case -1: // None
          break;
        case 0: // Hovering
          //println("Hovering (#"+finger_id+"): "+touch_distance);
          break;
        case 1: // Touching
          // println("Touching (#"+finger_id+")");
          break;
      }
    }
    
    // SORT THE Z POSITIONS
    fingersZ = sort(fingersZ);
    
    // TOOLS
    for(Tool tool : hand.getTools()){
      
      // Basics
      int     tool_id           = tool.getId();
      PVector tool_position     = tool.getPosition();
      PVector tool_stabilized   = tool.getStabilizedPosition();
      PVector tool_velocity     = tool.getVelocity();
      PVector tool_direction    = tool.getDirection();
      float   tool_time         = tool.getTimeVisible();
      
      // Touch Emulation
      int     touch_zone        = tool.getTouchZone();
      float   touch_distance    = tool.getTouchDistance();
      
      switch(touch_zone){
        case -1: // None
          break;
        case 0: // Hovering
          // println("Hovering (#"+tool_id+"): "+touch_distance);
          break;
        case 1: // Touching
          // println("Touching (#"+tool_id+")");
          break;
      }
    }
    
  }
  
  //println("number of fingers: " + fingers);
  String zees = ""; 
  if(fingers>=1)
  {
    println("More than one fingers");
  for(int i = 0; i<fingers; i++ )
  {
    if( fingersArray[i].z > 60)
    {
    if(fingersArray[i].z == fingersZ[19] )
    {
      
      fill(255,0,0,255);
      ellipse(fingersArray[i].x,fingersArray[i].y,15,15);
      println("Finger is in the right zone x: "+fingersArray[i].x+" y: "+fingersArray[i].y);
      drawIt(new PVector(fingersArray[i].x,fingersArray[i].y), true);
      
    }
    }
    else
    {
      if(fingersArray[i].z == fingersZ[19] )
    {
      
      fill(10,0,0,255);
      ellipse(fingersArray[i].x,fingersArray[i].y,15,15);
      currentWayPoint.x = -5555;
    }
      
    }
  }
  }
  else
  {
    println("No fingers");
  }
 /*
 stroke(255,0,0);
 strokeWeight(1);
 fill(0,0,0,0);
 rect(250, 100, 300, 300);
 */ 
}

PVector currentWayPoint = new PVector(-5555,0);

void drawIt(PVector point)
{
  drawIt( point, false );
}

// DRAWING THE FINGER MOVEMENT
void drawIt( PVector point, boolean record )
{
  println("DRAW IT!");
  
  // RECORD THE MOVEMENT
  if(record) points = (PVector[]) append(points, new PVector(point.x,point.y));
  
  // WAIT UNTIL YOU HAVE TWO POINTS
  if(currentWayPoint.x!=-5555)
  {
 
  // DRAWING THE LINE  
  pg.beginDraw();
  if(record) pg.stroke(0,0,0,255);
  else{
    pg.pushMatrix(); 
    pg.translate(30, 20);
    pg.stroke(255,0,0,255); 
  }
  pg.strokeWeight(1);
  pg.ellipse(point.x, point.y,2,2);
  pg.line( currentWayPoint.x, currentWayPoint.y, point.x, point.y );
  pg.endDraw();
  int xTemp = int(map(point.x,0,800,0,150));
  int yTemp = int(map(point.y,0,500,0,150));
  int x = (xTemp<0)? 0:xTemp;
  int y = (yTemp<0)? 0:yTemp;
  if(!record) pg.popMatrix();
  
  myPort.write("G1 X"+x+" Y"+y+" \r\n");
  }
  else{
  println("Reseting path");
  }
  
  currentWayPoint.x = point.x;
  currentWayPoint.y = point.y;
  
}

void leapOnInit(){
  // println("Leap Motion Init");
}
void leapOnConnect(){
  // println("Leap Motion Connect");
}
void leapOnFrame(){
  // println("Leap Motion Frame");
}
void leapOnDisconnect(){
  // println("Leap Motion Disconnect");
}
void leapOnExit(){
  // println("Leap Motion Exit");
}

String textHistory = "";
String lastCommand = "";

// SIMPLIFY THE PATH
public void SIMPLIFY() {
 PVector[] simplifiedVectors = new PVector[points.length];
 println(points.length);
  println("\n\r");
 simplifiedVectors = Simplify.simplify(points, 16, true);
 println(simplifiedVectors.length);
 currentWayPoint.x = -5555;

 for(PVector point : simplifiedVectors )
 {
   drawIt(point, false);
 }

}

public void KILLALL() {
 println("kill all");
 myPort.write("M124\r\n");
}

public void SEND() {
  lastCommand = cp5.get(Textfield.class,"input").getText();
  // APPEND TEXT TO HISTORY
  textHistory = lastCommand+"\r\n"+textHistory;
  // PASTE TEXT UNDERNEATH
  updateText(textHistory);
  // CLEAR TEXT FROM INSIDE THE TEXT FIELD
  cp5.get(Textfield.class,"input").clear();
  // SEND COMMAND TO SERIAL PORT
  myPort.write(lastCommand+"\r\n");
}

void keyPressed()
{
  if(key == ENTER) {
  println("ENTER PRESSED");
  if(cp5.get(Textfield.class,"input").isFocus())
  {
    SEND();
  }
  
}
else if(keyCode == UP) {
  println("up"+lastCommand);
  cp5.get(Textfield.class,"input").setFocus(false);
  cp5.get(Textfield.class,"input").setText(lastCommand);
}
}

void updateText(String value)
{
 text(value, 20,150); 
}


