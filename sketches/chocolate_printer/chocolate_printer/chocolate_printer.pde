import processing.serial.*;
import controlP5.*;
import java.awt.event.KeyEvent;

 double initial_time;
Serial myPort;
Boolean inited = false;
int lf = 10;    // Linefeed in ASCII
String myString = null;
float[][] sfPoints = new float[2][2];
int clickCounter = 0;
ArrayList<PVector> points = new ArrayList<PVector>();
int d = day(); 
int m = millis();

/*
MAX VALUES
Z -100
X,Y -60-60
E 0-1240
G1 E10 F1000
*/

void setup()
{  
  size(200, 200);
initial_time = millis();
  //initialize the serial port to talk to the printer
  //println(Serial.list());
  // MAKE SURE YOU ARE USING THE RIGHT SERIAL PORT AND BAUTRATE
  //myPort=new Serial(this, Serial.list()[5], 115200);
  // create a delay effect
  // DRAW BUTTONS
  noStroke();
  fill(0,0,255);
  rect(0, 0, 10, 10);
  stroke(0,0,0);
strokeWeight(1);
}

void initPrinter()
{
 
    
//myPort.write("G21\r\n");
//   myPort.write("G28\r\n");
//   myPort.write("M107\r\n");  
//    myPort.write("G90\r\n"); 
//    myPort.write("G1 Z-86.5 F3000\r\n"); 
   inited = true;
}

void keyPressed()
{
  println(keyCode);
  if(key == ENTER) {
  println("ENTER PRESSED");
  }
  
}

float[] coor = {0,0};
float extrudedAmmount = 0;

void draw()
{
  
  // INITIALISE 3D PRINTER
  //if(millis()>2000 && inited != true) 
  //{
  //  initPrinter();
  //}  
  //while (myPort.available() > 0) {
  //  myString = myPort.readStringUntil(lf);
  //  if (myString != null) {
  //    println(myString);
  //  }
  //}
  
  // IF BOTH POINTS ARE AVAILABLE DRAW THE LINE
  if( clickCounter==2)
  {
    //line(sfPoints[0][0], sfPoints[0][1], sfPoints[1][0], sfPoints[1][1]);
    float x0 = map(sfPoints[0][0], 0, 200,-60, 60);
    float y0 = map(sfPoints[0][1], 0, 200,60, -60);
    float x1 = map(sfPoints[1][0], 0, 200,-60, 60);
    float y1 = map(sfPoints[1][1], 0, 200,60, -60);
    float distance = dist(x0, y0, x1, y1)/1.8;
    println(distance);
    extrudedAmmount += distance;
    //int speed = (int)distance*10;
    println(extrudedAmmount);
    //myPort.write("G0 Z-70 F3000\r\n"); 
    //myPort.write("G0 X"+x0+" Y"+y0+" F3000 \r\n");
    //myPort.write("G0 Z-86.5 F3000\r\n"); 
    //myPort.write("G1 E"+20+" F1000\r\n");
    //myPort.write("G1 X"+x1+" Y"+y1+" E"+extrudedAmmount+" F1000\r\n");
    //extrudedAmmount -=30;
    //myPort.write("G1 E"+extrudedAmmount+" F1000\r\n");
    //XXXXXXXX LEAVE COMMENTED OUT XXXXXXXXXXXXXXXXXXX
    //myPort.write("G1 X"+x1+" Y"+y1+" F1000\r\n"); //
    //myPort.write("G1 E"+distance+" F1000\r\n");   //
    //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    println("DRAW");
    clickCounter = 0;
  }
  
}

//void mouseDragged()
//{
//  //println("dragged");
//  float[] currentCoor = {mouseX,mouseY};
//  line(coor[0], coor[1], currentCoor[0], currentCoor[1]);
//  coor = currentCoor;
//  float x = map(currentCoor[0], 0, 200,-60, 60);
//  float y = map(currentCoor[1], 0, 200,60, -60);
//  myPort.write("G1 X"+x+" Y"+y+" \r\n");
//  // EXTRUSION
//  // G1 E5 F500 ;AMMOUNT SPEED
//  // 
//  //println(map(currentCoor[0], 0, 200,-60, 60)+" "+map(currentCoor[1], 0, 200, 60, -60));
//  //println("X> "+x+" - Y>"+y);
//  
//}

ArrayList<String> fileString = new ArrayList<String>(); 
int pointsNo;

void mouseReleased()
{
  if(mouseX>10 && mouseY>10){
  sfPoints[clickCounter][0] = mouseX;
  sfPoints[clickCounter][1] = mouseY;
  clickCounter++;
  // SAVE POINT DATA
  //point(30, 20);
  points.add(new PVector(mouseX,mouseY));
  pointsNo = points.size();
  if(pointsNo>1)
  {
    println("POINT"+points.get(pointsNo-1).x);
  line(points.get(pointsNo-2).x, points.get(pointsNo-2).y, points.get(pointsNo-1).x, points.get(pointsNo-1).y);
  }
  }
}

void mousePressed()
{
  if(mouseX<=10 && mouseY<=10)
  {
    String[] pointsString = new String[pointsNo];
    // SAVE FILE
    int arrayPointer = 0;
     for (PVector point : points) {
      println(point);
      pointsString[arrayPointer] = str(point.x)+","+str(point.y);
      arrayPointer++;
    }
    saveStrings("shape"+str(d)+str(m)+".txt",pointsString );
  }
  //saveStrings("shape"+str(d)+str(m)+".txt",fileString );
  //coor[0] = mouseX;
  //coor[1] = mouseY;
  //println("pressed");
}