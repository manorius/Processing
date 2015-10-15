/*
Fillament extrusion calculation
println(dist(51.5, 22, 51.5, 23.5));
//println(map(76.210,));

2.41    0.133778 
1         x


x = 0.133778/2.41
1mm -> E0.055509544 
x   -> 

PLACEMENT OF PAPER
________________________________________.....
|                 ↑
|                14
|                 ↓ 
|           ________________
|<--86mm-->|
|          |
|          |
|
|
|

*/

import simplify.*;
import processing.serial.*;

boolean firstPress = true;
int totalPoints = 0;
// PRINTBED AREA
int pbSize = 306;
float pbStart = (500-pbSize)/2;
float pbEnd   = (500-pbSize)/2+pbSize;
Serial myPort;
PImage card;
PGraphics pg;
int canvasW = 1000;
int canvasH = 800;
int drawArea = 240;
String displayTxt = "3d.dimsumlabs.com/";
PFont courier;
int newID;
JSONObject json;
float clientW = 0;
float clientH = 0;
int noOfPoints = 0;
float xOffset = 52;
float yOffset = 20;
float printBed = 153;
// PRINT BED AREA
float pBA = 51;
PVector[] points = new PVector[0];//{ new PVector(0+xOffset,0+yOffset), new PVector(51+xOffset,0+yOffset), new PVector(51+xOffset,51+yOffset), new PVector(0+xOffset,51+yOffset),  new PVector(0+xOffset,0+yOffset) };
PVector[] previewPoints = new PVector[0];

void setup()
{
  
  size(canvasW, canvasH);
  background(255);
  pg = createGraphics(canvasW, canvasH);
  pg.beginDraw();
  pg.endDraw();
  
  // COPY CARD
  card = loadImage("graphic.png");
  image(card, (canvasW - 472) / 2, (canvasH - 708) / 2 );
  
  // CONNECT TO PRINTER AND SEND COMMANDS
  myPort=new Serial(this, Serial.list()[2], 250000);
  printArray(Serial.list());
  myPort.write("G21\r\n");
   myPort.write("G28\r\n");
   myPort.write("M107\r\n"); 
   myPort.write("G1 Z10\r\n"); 
   myPort.write("M106 S255\r\n"); 
   myPort.write("G90\r\n"); 
   myPort.write("M82\r\n"); 
   myPort.write("M104 S200\r\n");
   myPort.write("M109 S200\r\n");
   myPort.write("G1 X0 Y0 Z5\r\n");
   myPort.write("G92 E0\r\n");
}

void draw()
{
  background(255);
  // ADD TEXT
  fill(0xffff0000);
  courier = loadFont("Courier.vlw");
  textFont(courier);
  textSize(20);
  text( displayTxt+newID, 350, 30 );
  
  // PLACE CARD
  image(card, (canvasW - 472) / 2, (canvasH - 708) / 2 );
  
  // BUTTONS
  // GENERATE ID
  fill(0xff919191);
  noStroke();
  rect(270,760,100,30);
  fill(0);
  text( "New ID", 285, 780 );
  
  // PREVIEW
  fill(0xff919191);
  rect(450,760,100,30);
  noStroke();
  fill(0);
  text( "Preview", 457, 780 );
  
  // PRINT
  fill(0xff919191);
  rect(630,760,100,30);
  noStroke();
  fill(0);
  text( "Print", 655, 780 );
  
  // MAIN RECT
  noFill();
  stroke(0);
  rect(379,165,drawArea,drawArea);
  
  // ADD THE GRAPHICS BUFFER
  image(pg, 0, 0);

}

void newId()
{
  // GENERATE RANDOM NUMBER
  newID = int( random(100, 999) );
  // UPDATE NUMBER ON SERVER
  json = loadJSONObject("http://3d.dimsumlabs.com/update"+newID);
  println(json);
}

void preview()
{
 json = loadJSONObject("http://3d.dimsumlabs.com/"+567+"coordinates"); 
 //float[] = json.getJSONArray("screen");
 // EXTRACT SIZE OF CLIENT SCREEN
 String status = "Expired Number";
 println(json);
 
 clientW = json.getJSONArray("screen").getFloat(0);
 clientH = json.getJSONArray("screen").getFloat(1);
   pg.clear();
   pg.beginDraw();
   pg.pushMatrix(); 
   pg.translate(379,165);
   pg.strokeWeight(3);
   pg.stroke(255);
   
  // EXTRACT COORDINATES
  noOfPoints = json.getJSONArray("coor").size();
  
  // RESET 
  previewPoints = new PVector[0];
  
  for( int i = 0; i< noOfPoints;i++)
  {
    // REMAP TO CANVAS
    // Converted X
    float x = map(json.getJSONArray("coor").getJSONArray(i).getFloat(0), 0, clientW, 0, drawArea);
    // Converted Y
    float y = map(json.getJSONArray("coor").getJSONArray(i).getFloat(1), 0, clientH, 0, drawArea);
    
    // APPEND NEW POINTS TO PVector
    previewPoints = (PVector[]) append(previewPoints, new PVector( x, y ));

    // START DRAWING
    if(i>0) pg.line( previewPoints[i-1].x, previewPoints[i-1].y, previewPoints[i].x, previewPoints[i].y );  

}
  println(previewPoints);
 
  pg.stroke(0);
  
  pg.endDraw();
  
}

void animateDrawing()
{
  //pg.clear();
   pg.beginDraw();
   pg.pushMatrix(); 
   pg.translate(379,165);
   pg.strokeWeight(1);
   pg.stroke(0xff00ff00);
   
   float centerX = drawArea / 2;
   float centerY = drawArea / 2;
   float angle = 0;
   float pi    = (float) Math.PI;
   float slice = pi * 2 / 100;

    
      pg.ellipse( centerX, centerY, 5, 5 );  
    // START DRAWING
    for(int k=0;k<100;k++)
{
    angle = 66*slice;
    float times = angle/slice;
    float mathCos = (float) Math.cos(66*slice);
    float mathSin = (float) Math.sin(66*slice);
    
    float radius1 = dist( centerX, centerY, previewPoints[0].x, previewPoints[0].y );
    float prevX = centerX + mathCos * radius1;
    float prevY = centerY + mathSin * radius1;
    pg.ellipse( prevX, prevY, 5, 5 );  
}    
//    pg.ellipse( previewPoints[0].x, previewPoints[0].y, 5,5 );
  /*
  for( int i = 1; i< noOfPoints;i++)
  {
    
    angle = slice;
    float mathCos = (float) Math.cos(angle);
    float mathSin = (float) Math.sin(angle);
    
    float radius1 = dist( centerX, centerY, previewPoints[i-1].x, previewPoints[i-1].y );
    float prevX = centerX + mathCos * radius1;
    float prevY = centerY + mathSin * radius1;
    float radius2 = dist( centerX, centerY, previewPoints[i].x, previewPoints[i].y );
    float X = centerX + mathCos * radius2;
    float Y = centerY + mathSin * radius2;
    
    // START DRAWING
    pg.line( prevX, prevY, X, Y );  

}

 for( int i = 0; i< noOfPoints;i++)
  {
    
      
    
    
    // START DRAWING
    pg.ellipse( previewPoints[i].x, previewPoints[i].y, 5,5 );  

}
*/

  //println(previewPoints);
 
  pg.stroke(0);
  
  pg.endDraw();
}


// HEIGHT START
 float zHeight = 0;
 // EXTRUDE START
 float extrude = 0;
 // AMOUNT TO EXTRUDE ~0.055509544 FOR F600 ALTHOUGH 0.025509544 IS ALSO WORKING FINE;
 float ammount = 0.1;
 // NUMBER OF LAYERS
 int nol = 20;
 boolean reset = false;
 
void printIt()
{
  // REMAP PREVIEW POINTS TO PRINTBED POINTS
  for(int i=0; i<noOfPoints; i++)
  {
    points = (PVector[]) append(points, new PVector( map(previewPoints[i].x, 0, drawArea, 0, pBA), map(previewPoints[i].y, 0, drawArea, 0, pBA)));
  }
 println(noOfPoints+" - "+points.length);
  
  // START PRINTING
  myPort.write("G1 F2000.000 Z"+zHeight+" \r\n");
   
  // NUMBER OF LAYERS
  for(int layer=0;layer<nol;layer++)
  {
   
    zHeight += 0.32;
    // FILLAMENT EXTRUTION PER MM TRAVELED 1mm -> E0.055509544  
   // GO TO THE START OF THE PATH
   float x = ( -1 * points[0].x ) + ( 2 * xOffset );
   float y = points[0].y + yOffset;
   
   myPort.write("G1 X"+x+" Y"+y+" Z"+zHeight+" \r\n");
  // println("G1 X"+(points[0].x-pbStart)/2+" Y"+(points[0].y-pbStart)/2+" \r\n");
   
  for(int i=1; i<points.length;i++)
  {
    
    x = ( -1 * points[i].x ) + ( 2 * xOffset ) ;
    y = points[i].y + yOffset;
    
    // CALCULATE DISTANCE
    float distance = dist(( -1 * points[i-1].x ) + ( 2 * xOffset ), points[i-1].y + yOffset, x, y);
    extrude  += distance * ammount; 
    println(extrude);
    
    // MOVE AND PRINT
    myPort.write("G1 X"+x+" Y"+y+" E"+extrude+" \r\n");
   // println("DISANCE PRevious X "+((points[i-1].x-pbStart)/2)+" Previous Y "+((points[i-1].y-pbStart)/2)+" new X "+x+" new Y "+y+"\n");
   // println("G1 X"+x+" Y"+y+" E"+extrude+" \r\n");
  }
  }
  
  // MOVE TO HOME X0 Y0
  myPort.write("G1 Z10 \r\n");
  myPort.write("G1 X0 Y0 F1800 \r\n");
  reset = true;
  
  // RESET HEIGHT
  zHeight = 0;
  
  // RESET THE ARRAY
  points = (new PVector[0]);
  
  
}

void resetMe()
{
  
  
}

void mousePressed()
{
 // NEW URL 270,760,100,30
if(mouseX >= 270 && mouseY >= 760 && mouseX<=370 && mouseY<=790)
{
  println("NEW URL");
  newId();
}
// PREVIEW 450,760,100,30
else if(mouseX >= 450 && mouseY >= 760 && mouseX<=550 && mouseY<=790)
{
  println("PREVIEW");
  preview();
}
// PRINT 630,760,100,30
else if(mouseX >= 630 && mouseY >= 760 && mouseX<=730 && mouseY<=790)
{
  //println("PRINT");
  //printIt();
  //animateDrawing();
  printIt();
}  
  
}

