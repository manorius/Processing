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

void setup()
{
  
  size(500, 500);
  background(255);
  myPort=new Serial(this, Serial.list()[2], 250000);
  myPort.write("G21\r\n");
   myPort.write("G28\r\n");
   myPort.write("M107\r\n"); 
   myPort.write("G1 Z10\r\n"); 
   myPort.write("M106 S255\r\n"); 
   myPort.write("G90\r\n"); 
   myPort.write("M82\r\n"); 
   myPort.write("M104 S200\r\n");
   myPort.write("M109 S200\r\n");
   myPort.write("G1 X0 Y0 Z0\r\n");
   myPort.write("G92 E0\r\n");
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
 
 boolean onClick = false;
 // HEIGHT START
 float zHeight = 0;
 // EXTRUDE START
 float extrude = 0;
 // AMOUNT TO EXTRUDE ~0.055509544 FOR F600 ALTHOUGH 0.025509544 IS ALSO WORKING FINE;
 float ammount = 0.055509544;
 // NUMBER OF LAYERS
 int nol = 25;
 
// MOUSE POSITION WHEN THE MOUSE BUTTON WAS PRESSED 
PVector initPressMousePos = new PVector(0,0);
void mousePressed()
{
 if(mouseX >= 490 && mouseY >= 490 && mouseX<=500 && mouseY<=500)
 {
   displayTxt = "Simplify";
   println("buton pressed"); 
   println(points.length);
   PVector[] simplifiedVectors = new PVector[points.length];
   simplifiedVectors = Simplify.simplify(points, 14, true);
 println(simplifiedVectors.length);
  for(int i=0; i<simplifiedVectors.length-1;i++)
  {
    drawLines(simplifiedVectors[i], simplifiedVectors[i+1], true);
  }
 }
 else if(mouseX >= 480 && mouseY >= 490 && mouseX<=489 && mouseY<=500)
 {
   println(points);
   myPort.write("G1 F600.000 Z"+zHeight+" \r\n");
   
  // NUMBER OF LAYERS
  for(int layer=0;layer<nol;layer++)
  {
   zHeight += 0.32;
    // FILLAMENT EXTRUTION PER MM TRAVELED 1mm -> E0.055509544  
   // GO TO THE START OF THE PATH
   myPort.write("G1 X"+(points[0].x-pbStart)/2+" Y"+(points[0].y-pbStart)/2+" Z"+zHeight+" \r\n");
   println("G1 X"+(points[0].x-pbStart)/2+" Y"+(points[0].y-pbStart)/2+" \r\n");
   
  for(int i=1; i<points.length;i++)
  {
    
    displayTxt = "Print";
    float x = (points[i].x-pbStart)/2;
    float y = (points[i].y-pbStart)/2;
    // CALCULATE DISTANCE
    float distance = dist((points[i-1].x-pbStart)/2, (points[i-1].y-pbStart)/2, x, y);
    extrude  += distance * ammount; 
    // MOVE AND PRINT
    myPort.write("G1 X"+x+" Y"+y+" E"+extrude+" \r\n");
    println("DISANCE PRevious X "+((points[i-1].x-pbStart)/2)+" Previous Y "+((points[i-1].y-pbStart)/2)+" new X "+x+" new Y "+y+"\n");
    println("G1 X"+x+" Y"+y+" E"+extrude+" \r\n");
  }
  }
  
  // MOVE TO HOME X0 Y0
  myPort.write("G1 Z10 \r\n");
  myPort.write("G1 X0 Y0 F1800 \r\n");
  println("button 2 pressed"+" - PRINT"); 
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
 }
 else
 {
  println("mouse pressed"); 
   
 }
 
 initPressMousePos = new PVector(mouseX,mouseY);
  
}
