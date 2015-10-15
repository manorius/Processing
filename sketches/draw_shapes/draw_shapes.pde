// Example 02-02 from "Getting Started with Processing" 
// by Reas & Fry. O'Reilly / Make 2010

ArrayList points = new ArrayList();
Boolean clear = false;

void setup() {
  size(800, 600);
  background(51);
  smooth();

}

void draw() {
  // buildShape();
 /* if (mousePressed) {
    fill(0);
  } else {
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
  */
  
  
}

void mouseDragged() 
{
 clearCanvas();
 float[] xy = {mouseX,mouseY};
 points.add(xy);

buildShape();
 clear = false;
  /*background(51);
  line(0, 0, mouseX, mouseY);
stroke(255);
redraw();*/
}

void mouseReleased()
{
  clear = true;
}

void clearCanvas()
{
 if(clear==true)
 {
  points.clear();
  background(51);
 } 
}

void buildShape()
{
  background(51);
  strokeJoin(ROUND);
  strokeWeight(10);
  fill(153);
beginShape();

 for(int n=0;n<points.size();n++)
{
   vertex(((float[])points.get(n))[0],((float[])points.get(n))[1]);
   stroke(#E07000);
   
   //println( ((float[])points.get(n)) );

}

print(points.size());
   print("-----------");  


endShape(CLOSE);

}



/*

*/


/*void addLine(x1,y1,x2,y2)
{
  
 line(30, 20, 85, 20);
stroke(126);
line(85, 20, 85, 75);
stroke(255);
line(85, 75, 30, 75); 
  
  
}*/
