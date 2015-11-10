import processing.serial.*;
import controlP5.*;
import java.awt.event.KeyEvent;

  PImage img;
double initial_time;
Serial myPort;
Boolean inited = false;
int lf = 10;    // Linefeed in ASCII
String myString = null;
float[][] sfPoints = new float[2][2];
int clickCounter = 0;
ArrayList<PVector> capturedPoints = new ArrayList<PVector>();
ArrayList<PVector> loadedPoints;
int loadedPointsSize = 0;
int d = day(); 
int m = millis();
int lastTimeCheck;
int timeIntervalFlag = 200; // 3 seconds because we are working with millis
int printing = 0;
String lowZ = "-82";
String highZ = "-70";
// DELAY IN MILLIS
int delay = 8000;
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
  lastTimeCheck = millis();
initial_time = millis();
  //initialize the serial port to talk to the printer
  println(Serial.list());
  // MAKE SURE YOU ARE USING THE RIGHT SERIAL PORT AND BAUTRATE
  myPort=new Serial(this, Serial.list()[5], 115200);
  // create a delay effect

  img = loadImage("logo.jpg");
image(img, 0, 0);
  // DRAW BUTTONS
  noStroke();
  // RECORD
  fill(0,0,255);
  rect(0, 0, 10, 10);
  // PLAYBACK
  fill(0,255,0);
  rect(10, 0, 10, 10);
  // INIT PRINTER
  fill(255,0,255);
  rect(190,0,10,10);
  // MOVE EXTRUDER TO 0
  fill(100,100,100);
  rect(180,0,10,10);
  stroke(0,0,0);
strokeWeight(1);

}

void initPrinter()
{

//
//             y:60 
//        |------------|
//        |            |
//        |            |
// x:-60  |            |  x:60
//        |            |
//        |------------|
//             y:-60
//
//

myPort.write("G21\r\n");
  myPort.write("G28\r\n");
  myPort.write("M107\r\n");  
   myPort.write("G90\r\n"); 
   myPort.write("G1 X-60 Y60 Z-70 F3000\r\n"); 
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
  
  ////INITIALISE 3D PRINTER
  if(millis()>2000 && inited != true) 
  {
  initPrinter();
  }  
  while (myPort.available() > 0) {
  myString = myPort.readStringUntil(lf);
  if (myString != null) {
    println(myString);
  }
  }
  
  //// IF BOTH POINTS ARE AVAILABLE DRAW THE LINE
  if( clickCounter==2)
  {
  //  //line(sfPoints[0][0], sfPoints[0][1], sfPoints[1][0], sfPoints[1][1]);
  //  float x0 = map(sfPoints[0][0], 0, 200,-60, 60);
  //  float y0 = map(sfPoints[0][1], 0, 200,60, -60);
  //  float x1 = map(sfPoints[1][0], 0, 200,-60, 60);
  //  float y1 = map(sfPoints[1][1], 0, 200,60, -60);
  //  float distance = dist(x0, y0, x1, y1)/1.8;
  //  println(distance);
  //  extrudedAmmount += distance;
  //  //int speed = (int)distance*10;
  //  println(extrudedAmmount);
  //  //myPort.write("G0 Z-70 F3000\r\n"); 
  //  //myPort.write("G0 X"+x0+" Y"+y0+" F3000 \r\n");
  //  //myPort.write("G0 Z-86.5 F3000\r\n"); 
  //  //myPort.write("G1 E"+20+" F1000\r\n");
  //  //myPort.write("G1 X"+x1+" Y"+y1+" E"+extrudedAmmount+" F1000\r\n");
  //  //extrudedAmmount -=30;
  //  //myPort.write("G1 E"+extrudedAmmount+" F1000\r\n");
  //  //XXXXXXXX LEAVE COMMENTED OUT XXXXXXXXXXXXXXXXXXX
  //  //myPort.write("G1 X"+x1+" Y"+y1+" F1000\r\n"); //
  //  //myPort.write("G1 E"+distance+" F1000\r\n");   //
  //  //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  //  println("DRAW");
    clickCounter = 0;
  }
  
  // DRAW WITH THE PRINTER
  if ( millis() > lastTimeCheck + timeIntervalFlag ) {
    lastTimeCheck = millis();
    //extrudedAmmount-=10;
    //myPort.write("G1 E"+extrudedAmmount+" F1000\r\n");
    //println( "something awesome happens here" );
    
    if( printing >= 1 )
    {
      
      println(printing+" "+str(printing<loadedPointsSize)+" "+loadedPointsSize);
       
       // MAP TO PRINTER COORDINATES
       float x0 = map(loadedPoints.get(printing-1).x, 0, 200,-35, 35);
       float y0 = map(loadedPoints.get(printing-1).y, 0, 200,35, -35);
     
        // MOVE PRINTHEAD
        // IT MOVES AT 1MM PER 0.019791667 sec
        
        if(printing == 1)
        {
          extrudedAmmount+=5;
          myPort.write("G0 Z"+lowZ+" F3000\r\n");
          myPort.write("G1 X"+x0+" Y"+y0+" E"+extrudedAmmount+" F3000 \r\n");
          myPort.write("G1 E"+extrudedAmmount+" F3000 \r\n");
          delay(delay);
        }
        
        myPort.write("G1 X"+x0+" Y"+y0+" E"+extrudedAmmount+" F1000 \r\n");
        
      if(printing<loadedPointsSize){
       float x1 = map(loadedPoints.get(printing).x, 0, 200,-35, 35);
       float y1 = map(loadedPoints.get(printing).y, 0, 200,35, -35);
  // STOP EXTRUDING 10 POINTS BEFORE THE END
  extrudedAmmount+=(printing>loadedPointsSize-25)? 0:dist(x0, y0, x1, y1)/8;
  println("moved: "+dist(x0, y0, x1, y1));
        // DRAW LINE
        stroke(random(254),random(254),random(254));
      line(loadedPoints.get(printing-1).x,loadedPoints.get(printing-1).y,loadedPoints.get(printing).x,loadedPoints.get(printing).y);
      printing++;
      }
      else
      {
        printing = 0;
        myPort.write("G0 Z"+highZ+" F3000\r\n");
      }
    }
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
  capturedPoints.add(new PVector(mouseX,mouseY));
  pointsNo = capturedPoints.size();
  if(pointsNo>1)
  {
    //println("POINT"+ capturedPoints.get(pointsNo-1).x);
  line( capturedPoints.get(pointsNo-2).x, capturedPoints.get(pointsNo-2).y, capturedPoints.get(pointsNo-1).x, capturedPoints.get(pointsNo-1).y);
  }
  }
}

void mousePressed()
{
  loadedPoints = new ArrayList<PVector>();
  
  if(mouseX<=10 && mouseY<=10)
  {
    String[] pointsString = new String[pointsNo];
    // SAVE FILE
    int arrayPointer = 0;
     for (PVector point : capturedPoints) {
      //println(point);
      pointsString[arrayPointer] = str(point.x)+","+str(point.y);
      arrayPointer++;
    }
    saveStrings("shape"+str(d)+str(m)+".txt",pointsString );
  }
  else if(mouseX>=10 && mouseX<=20 && mouseY<=10)
  {
    // PLAYBACK
    String lines[] = loadStrings("shape1027.txt");
stroke(random(254),random(254),random(254));


for (int i = 0 ; i < lines.length; i++) {
  //println(lines[i]);
  String[] point = split(lines[i] ,",");
  loadedPoints.add(new PVector(Float.valueOf(point[0]),Float.valueOf(point[1])));
if(i>0){
  //line(loadedPoints.get(i-1).x,loadedPoints.get(i-1).y,loadedPoints.get(i).x,loadedPoints.get(i).y);
  printing = 1;
}
}

loadedPointsSize = loadedPoints.size();
    
  }
  else if(mouseX>=190 && mouseX<=200 && mouseY<=10)
  {
    initPrinter();
  }
  else if(mouseX>=180 && mouseX<=190 && mouseY<=10)
  {
    //myPort.write("G1 E0 F3000 \r\n");
  }
  //saveStrings("shape"+str(d)+str(m)+".txt",fileString );
  //coor[0] = mouseX;
  //coor[1] = mouseY;
  //println("pressed");
}