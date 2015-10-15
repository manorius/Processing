// Use the included processing code serial library
import processing.serial.*;        

Serial port;                         // The serial port

int spos=0;

void setup() 
{
  size(640, 720);
  colorMode(RGB, 1.0);
  noStroke();
  rectMode(CENTER);
  frameRate(100);

  println(Serial.list()); // List COM-ports

  //select second com-port from the list
  port = new Serial(this, Serial.list()[0], 9600); 
  
port.bufferUntil('\n');
}

void serialEvent(Serial myPort)
{
  boolean validString = true;  // whether the string you got is valid
  String errorReason = "";     // a string that will tell what went wrong

  // read the serial buffer:
  String myString = port.readStringUntil('\n');

  // make sure you have a valid string:

  if (myString != null)
  {
     println("Received: [" + myString + "]");
  }
}

void draw() 
{
  background(0.0);
  update(mouseX); 
}

int tempMouseX = 0;
boolean toggle = false;

void update(int x) 
{
  //Calculate servo postion from mouseX
  spos= int(floor(map(mouseX,0,640,180,60)));
  
  

  //Output the servo position ( from 0 to 180)

String passToArduino = "l"+spos+"r"+300;
if(toggle){
  port.write("a"); 
  toggle = false;
}else
{
  port.write("b"); 
  toggle = true;
}
  //port.write('\n');
  //println(spos);
}

