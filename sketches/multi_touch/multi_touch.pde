import android.view.MotionEvent;
import java.util.Iterator;

float sw, sh, touchX, touchY; 
int pointerCount; 
ArrayList points; 
PFont f;  

void setup() 
{  
//size doesn't really matter in an Android app 
size(displayWidth, displayHeight); 
println(displayWidth);  
println(displayHeight);  
sw = displayWidth; 
sh = displayHeight; 

points = new ArrayList(); 

f = createFont("Arial", 16);  
}   

void draw() 
{  

  
  background(0);  
smooth();  
noFill();  
stroke(255,0,0); 
strokeWeight(2);  
textFont(f);
PVector tempPoint; 

for(int i=0; i<points.size(); i++) 
 { 
 tempPoint = (PVector) points.get(i); 
 ellipse(tempPoint.x, tempPoint.y, 110, 110); 
 textSize(32);
 text(tempPoint.x+", "+tempPoint.y, tempPoint.x+10, tempPoint.y-100); 
 } /**/
}  


public boolean surfaceTouchEvent(MotionEvent event) { 
pointerCount = event.getPointerCount(); 
println("Number of pointers: "+pointerCount); 
points.clear(); 
for(int i=1; i<=pointerCount; i++) { 
points.add(new PVector(event.getX(i-1), event.getY(i-1))); 
}  

//if the event is a pressed gesture finishing,  
// it means the lifting the last touch point 
if(event.getActionMasked() == MotionEvent.ACTION_UP) points.clear();  
// if you want the variables for motionX/motionY, mouseX/mouseY etc. 
// to work properly, you'll need to call super.surfaceTouchEvent(). 
return super.surfaceTouchEvent(event);  

} 

/* 
if single touch is all you need, this would work just fine 
void mouseDragged() {  touchX = mouseX;  touchY = mouseY; } 
*/
