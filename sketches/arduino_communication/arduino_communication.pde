/* SendingBinaryToArduino * Language: Processing */
import processing.serial.*;

Serial myPort; // Create object from Serial class
public static final char HEADER = '|';
public static final char MOUSE = 'M';

void setup()
{
  size(100,100);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
}


void draw()
{
 int index = mouseY;
int value = mouseX; 
sendMessage(MOUSE, index, value); 
}

void serialEvent(Serial p) {

// handle incoming serial data
String inString = myPort.readStringUntil('\n');
if(inString != null) {
 println( inString );  // echo text string from Arduino 
}
  
}

void mousePressed() {
 


}

void sendMessage(char tag, int index, int value){
 
  // send the given index and value to the serial port 
  myPort.write(HEADER); 
  myPort.write(tag); 
  myPort.write(int(map(index,0,100,180,60))); 
  myPort.write(int(map(value,0,100,180,0))); 
  
}
