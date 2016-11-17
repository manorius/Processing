import processing.serial.*;
import http.requests.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

// I know that the first port in the serial list on my mac
// is Serial.list()[0].
// On Windows machines, this generally opens COM1.
// Open whatever port is the one you're using.
void setup()
{
 String portName = Serial.list()[5]; //change the 0 to a 1 or 2 etc. to match your port
myPort = new Serial(this, portName, 9600);  
myPort.bufferUntil('\n'); 
  
}

void draw()
{

}

void serialEvent( Serial myPort) {
//put the incoming data into a String - 
//the '\n' is our end delimiter indicating the end of a complete packet
val = myPort.readStringUntil('\n');
//make sure our data isn't empty before continuing
if (val != null) {
  //trim whitespace and formatting characters (like carriage return)
  val = trim(val);
  println(val.equals("Fork 1"));
  if(val.equals("Fork 1"))
  {
    int forkID = 1;
   GetRequest get = new GetRequest("http://localhost:4567/getReq?forkID="+forkID);
  get.send(); 
  }
  }
}
