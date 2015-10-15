import processing.serial.*;
import controlP5.*;
import java.awt.event.KeyEvent;

/*
/// MAX VALUES
/// x: 153 y:153 z:153
*/

Serial myPort;
ArrayList points;
PVector currentWaypoint;
boolean motionPlanned=false;
ControlP5 cp5;

String textValue = "";

void setup()
{  
  size(500, 580);
  PFont font = createFont("helvetica neue",20);
  
  // SETTING INPUT FIELD
  
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("input")
     .setPosition(20,70)
     .setSize(300,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,255))
     .setCaptionLabel("")
     ;
  
  // SETTING BUTTON
  cp5.addBang("SEND")
     .setPosition(340,70)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
  
    // KILL ALL
  cp5.addBang("KILLALL")
     .setPosition(340,10)
     .setSize(80,40)
     .setCaptionLabel("KILL ALL")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
  
  //initialize the serial port to talk to the printer
  println(Serial.list());
  // MAKE SURE YOU ARE USING THE RIGHT SERIAL PORT AND BAUTRATE
  myPort=new Serial(this, Serial.list()[5], 115200);
  //points=new ArrayList();
  // myPort.write("G21\r\n");
 //  myPort.write("G28\r\n");
 //  myPort.write("M107\r\n"); 
 //  myPort.write("G1 Z10\r\n"); 
   //myPort.write("M106 S255\r\n"); 
 //  myPort.write("G90\r\n"); 
 //  myPort.write("M82\r\n"); 
   //myPort.write("M104 S200\r\n");
   //myPort.write("M109 S200\r\n");
   //myPort.write("G1 X0 Y0 Z10\r\n");
   //myPort.write("G28\r\n");
  //delay(1000);
 /* home();
  points.add(new Point(new PVector(0, 0, 10)));
  points.add(new Point(new PVector(20, 20, 10), true));
  points.add(new Point(new PVector(20, -20, 10), true));
  points.add(new Point(new PVector(-20, -20, 10), true));
  points.add(new Point(new PVector(-20, 20, 10), true));
  points.add(new Point(new PVector(20, 20, 10), true));
  points.add(new Point(new PVector(0, 0, 10), true));
  points.add(new Point(new PVector(0, 0, 60), true));
  points.add(new Point(new PVector(0,0,80)));
  stream();*/
  
   textFont(font);
}

String textHistory = "";
String lastCommand = "";

public void KILLALL() {
 println("kill all");
 myPort.write("M124\r\n");
}

public void SEND() {
  lastCommand = cp5.get(Textfield.class,"input").getText();
  //println(currentText);
  // APPEND TEXT TO HISTORY
  textHistory = lastCommand+"\r\n"+textHistory;
  // PASTE TEXT UNDERNEATH
  updateText(textHistory);
  // CLEAR TEXT FROM INSIDE THE TEXT FIELD
  cp5.get(Textfield.class,"input").clear();
  //cp5.isFocus();
  // SEND COMMAND TO SERIAL PORT
  myPort.write(lastCommand+"\r\n");
  println(lastCommand);
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

void home()
{
 /* myPort.write("M107\r\n");
  myPort.write("G28\r\n");
  myPort.write("G90\r\n");*/
}

void draw()
{
  background(0);
  fill(255);
  updateText(textHistory);
  
  while (myPort.available() > 0) {
    int inByte = myPort.read();
    print(char(inByte));
    
  }
  
 /*  if(myPort.available()>0)
  {
   String s = myPort.readStringUntil('\n');
    if(s!=null)
    {
    println(s.trim());

    if (s.trim().startsWith("mm")) 
      motionPlanned=true;
    if(motionPlanned)
    if (s.trim().startsWith("ok")) 
    {
      println("moving on to the next command");
      stream();
    }
    if (s.trim().startsWith("error")) stream(); // XXX: really?
    }
 }*/ 

}

/*void stream()
{
  motionPlanned=false;
  if (points.size()>0)
  {
    Point point=(Point)points.get(0);
    println("moving to ("+point.point.x+", "+point.point.y+", "+point.point.z+")");
    if (point.pen)
      myPort.write("M106\r\n");  //turn on the ink
    myPort.write("G1 X"+point.point.x+" Y"+point.point.y+" Z"+point.point.z+"\r\n");  //the actual GCode motion command
    myPort.write("M107\r\n");  //turn off the ink once we're done moving  
    points.remove(0);
  }
}
*/

class Point {
 /* PVector point;
  boolean pen;
  Point(PVector _point, boolean _pen)
  {
    point=_point;
    pen=_pen;
  }
  Point(PVector _point)
  {
    point=_point;
  }*/
}

