import processing.video.*;

Capture video;  
boolean cheatScreen;



PFont font;
float fontSize = 1.5;
int scanPos = 0;
int y=0;
PImage recostructedVideo;
PImage[] buffer;
int timer;
int pos = 0;
int slitHeight = 0;
int slits = 70;

void setup() {
  size(640, 480);
  frameRate(60);
  video = new Capture(this, 640, 480);
  video.start(); 
  buffer = new PImage[slits];
  recostructedVideo = createImage(video.width,video.height,ARGB);
  
  for(int n = 0; n<slits;n++)
  {
    buffer[n] = createImage(video.width,video.height,ARGB);
  }
  
  slitHeight = video.height/slits;
  
}



void draw()
{
 
  
 if (millis() - timer >= 1) {
   
   
    timer = millis();
  
    println("time"+pos);
     video.read();
     
     pos = slits;
     
   for(int n = slits; n>0;n--)
     {
       int pos = n-1;
       
       if(n==1) buffer[n-1].copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
       else  buffer[n-1].copy(buffer[n-2],0,0,video.width,video.height,0,0,video.width,video.height);
       
       recostructedVideo.copy( buffer[n-1],0,pos*slitHeight,video.width,slitHeight,0,pos*slitHeight,video.width,slitHeight);
       
     }
   
   
   
    }
    
    
     image(recostructedVideo, 0, 0);
     

}

