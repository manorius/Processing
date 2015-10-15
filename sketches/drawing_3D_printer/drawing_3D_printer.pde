/*
Fillament extrusion calculation
println(dist(51.5, 22, 51.5, 23.5));
//println(map(76.210,));

2.41    0.133778 
1         x


x = 0.133778/2.41
1mm -> E0.055509544 
x   -> 
*/

import simplify.*;
import processing.serial.*;

boolean firstPress = true;
int totalPoints = 0;
// PRINTBED AREA
int pbSize = 306;
float pbStart = (500-pbSize)/2;
float pbEnd   = (500-pbSize)/2+pbSize;
String displayTxt = "-";
Serial myPort;
PFont courier;
float offsetY = 24;

void setup()
{
  
  size(500, 500);
  background(255);
  // MAKE SURE YOU ARE USING THE RIGHT SERIAL PORT AND BAUTRATE
  myPort=new Serial(this, Serial.list()[5], 115200);
//  myPort.write("G21\r\n");
//  myPort.write("G28\r\n");
//  myPort.write("M107\r\n"); 
//  myPort.write("G1 Z10\r\n"); 
//  myPort.write("M106 S255\r\n"); 
//  myPort.write("G90\r\n"); 
//  myPort.write("M82\r\n"); 
  //myPort.write("G1 X90 Y"+offsetY+" Z20 \r\n");
}

void draw()
{
  // DRAW BUTTON 1
  fill(0xffff0000);
  rect(490,490,10,10);
  // DRAW BUTTON 2
  fill(0xffffff00);
  rect(480,490,9,10);
  // DRAW BUTTON 3
  fill(0xffff00ff);
  rect(0,490,9,10);
  
  // DRAW DRAWING STAGE;
  stroke(0xff222222);
 noFill();
  // DOUBLE THE PRINTER SURFACE 2X153
  rect(pbStart,pbStart,pbSize,pbSize);
  //println(pbStart+" - "+pbStart+" size> "+pbSize+" "+pbSize);
  // DRAWING COOKIE
  // xMax:100
  // xMin:32
  // yMax:130
  // yMin:60
  // DELTA MAX-MIN
  
  ellipse( ((500-pbSize)/2)+140, ((500-pbSize)/2)+140, 140, 140 );
 
courier = loadFont("Courier.vlw");
textFont(courier);
textSize(20);
noStroke();
fill(0xffffffff);
rect( 9, 0, 300, 30 );
fill( 0, 102, 153 );
text( displayTxt, 10, 20 );
  
}

PVector[] points = new PVector[0];

void drawLines(PVector pPoint, PVector cPoint, boolean playBack)
{
  int strokeC = 0xffcccccc;
  PVector newPos = new PVector(0,0);
  
  if(playBack)
  {
    strokeC = 0xffff0000;
    newPos = new PVector(10,10);
    
  }
  else println(totalPoints);
  pushMatrix();
  translate(newPos.x,newPos.y);
  stroke(strokeC);
  noFill();
  line(pPoint.x,pPoint.y,cPoint.x,cPoint.y);
  ellipse(cPoint.x,cPoint.y,5,5);
  popMatrix();
}

void drawLines(PVector pPoint, PVector cPoint)
{
  drawLines(pPoint, cPoint, false);
}

void mouseDragged() 
{
  if( onClick != true )
 {
  float px = pmouseX;
  float py = pmouseY;
  
  if(firstPress)
  {
    firstPress = false;
    points = (PVector[]) append(points, new PVector(initPressMousePos.x,initPressMousePos.y));
    px = initPressMousePos.x;
    py = initPressMousePos.y;
  }
  drawLines( new PVector( px, py ),new PVector( mouseX, mouseY ));
  println("dragging"); 
  
  points = (PVector[]) append(points, new PVector(mouseX,mouseY));
  
  totalPoints++;
}
}

void mouseReleased()
{
  if(!onClick) firstPress = true;
  println("released pointsNo: "+totalPoints); 
  
}
 
 boolean onClick = true;
 // HEIGHT START
 float zHeight = 17;
 // EXTRUDE START
 float extrude = 1;
 // AMOUNT TO EXTRUDE ~0.055509544 FOR F600 ALTHOUGH 0.025509544 IS ALSO WORKING FINE;
 float ammount = 0.055509544;
 // NUMBER OF LAYERS
 int nol = 2;
 
// MOUSE POSITION WHEN THE MOUSE BUTTON WAS PRESSED 
PVector initPressMousePos = new PVector(0,0);
void mousePressed()
{
 if(mouseX >= 490 && mouseY >= 490 && mouseX<=500 && mouseY<=500)
 {
   displayTxt = "Simplify";
   println("simplify");
//   println("buton pressed"); 
//   println(points.length);
//   PVector[] simplifiedVectors = new PVector[points.length];
//   simplifiedVectors = Simplify.simplify(points, 14, true);
// println(simplifiedVectors.length);
//  for(int i=0; i<simplifiedVectors.length-1;i++)
//  {
//    drawLines(simplifiedVectors[i], simplifiedVectors[i+1], true);
//  }
 }
 else if(mouseX >= 480 && mouseY >= 490 && mouseX<=489 && mouseY<=500)
 {
   println("start printing");
   println(points);
   //myPort.write("G1 F1000.000 Z"+zHeight+" \r\n");
   
  // NUMBER OF LAYERS
//  for(int layer=0;layer<nol;layer++)
//  {
//   zHeight += 3;
//    // FILLAMENT EXTRUTION PER MM TRAVELED 1mm -> E0.055509544  
//   // GO TO THE START OF THE PATH
//   myPort.write("G1 X"+(points[0].x-pbStart)/2+" Y"+(((points[0].y-pbStart)/2)+offsetY)+" Z"+zHeight+" \r\n");
//   //println("G1 X"+(points[0].x-pbStart)/2+" Y"+(points[0].y-pbStart)/2+" \r\n");
//   
//  for(int i=1; i<points.length;i++)
//  {
//    
//    displayTxt = "Print";
//    float x = (points[i].x-pbStart)/2;
//    float y = min((((points[i].y-pbStart)/2)+offsetY),153);
//    // CALCULATE DISTANCE
//    float distance = dist((points[i-1].x-pbStart)/2, (points[i-1].y-pbStart)/2, x, y);
//    extrude  += distance * ammount; 
//    // MOVE AND PRINT
//    myPort.write("G1 X"+x+" Y"+y+" \r\n");
//    println("DISANCE PRevious X "+((points[i-1].x-pbStart)/2)+" Previous Y "+((points[i-1].y-pbStart)/2)+" new X "+x+" new Y "+y+"\n");
//    println("G1 X"+x+" Y"+y+" \r\n");
//  }
//  }
  
  // MOVE TO HOME X0 Y0
//  myPort.write("G1 Z20 F400 \r\n");
//  myPort.write("G1 X0 Y"+offsetY+" F1800 \r\n");
//  println("button 2 pressed"+" - PRINT"); 
  //var 
//  myPort.write("G21\r\n");
//  myPort.write("G28\r\n");
//  myPort.write("M107\r\n"); 
//  myPort.write("G1 Z10\r\n"); 
//  myPort.write("M106 S255\r\n"); 
//  myPort.write("G90\r\n"); 
//  myPort.write("M82\r\n"); 
// myPort.write("G1 Z-90 \r\n");
//  for(int p=0;p<totalPoints;p++)
//  {
//    //var newPoint =
//   //97.0 - 97.0 size> 306 306
//   println(p); 
//    println(points[p].x);
//    float xPos = map(points[p].x,97,403,-60,60);
//    float yPos = map(points[p].y,97,403,-60,60);
//        
//    myPort.write("G1 X"+xPos+" Y"+yPos+" \r\n");
//    println("G1 X"+xPos+" Y"+yPos+" \r\n");
//  }
   myPort.write("G28 \r\n");
    myPort.write("G1 Z-90 X0 Y0 \r\n");
    myPort.write("G1 X10 Y10 \r\n");
    myPort.write("G1 X10 Y-10 \r\n");
    myPort.write("G1 X-10 Y-10 \r\n");
    myPort.write("G1 X-10 Y10 \r\n");
    myPort.write("G1 X10 Y10 \r\n");
    myPort.write("G1 X20 Y20 \r\n");
    myPort.write("G1 X20 Y-20 \r\n");
    myPort.write("G1 X-20 Y-20 \r\n");
    myPort.write("G1 X-20 Y20 \r\n");
    myPort.write("G1 X20 Y20 \r\n");
    
  firstPress = true;
  
 }
 else if(mouseX >= 0 && mouseY >= 490 && mouseX<=10 && mouseY<=500)
 {
   displayTxt = "Click Drawing";
   onClick = (onClick)? false:true;
  println("button 3 pressed - onClick : " + onClick); 
   
 }
 else if(mouseX >= pbStart && mouseY >= pbStart && mouseX<= pbEnd && mouseY <= pbEnd )
 {
   println("INSIDE DRAWING AREA");
   float px = initPressMousePos.x;
  float py =  initPressMousePos.y;
  println(firstPress);
  
  if(firstPress)
  {
    initPressMousePos.x = mouseX;
    initPressMousePos.y = mouseY;
    firstPress = false;
    points = (PVector[]) append(points, new PVector(initPressMousePos.x,initPressMousePos.y));
    px = initPressMousePos.x;
    py = initPressMousePos.y;
  }
  else  points = (PVector[]) append(points, new PVector(mouseX,mouseY));
  
  drawLines( new PVector( px, py ),new PVector( mouseX, mouseY ));
  
  totalPoints++;
  println(points);
 }
 else
 {
  println("mouse pressed"); 
   
 }
 
 initPressMousePos = new PVector(mouseX,mouseY);
  
}
