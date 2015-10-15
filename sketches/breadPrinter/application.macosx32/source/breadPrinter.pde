/**
 * Brightness Thresholding 
 * by Golan Levin. 
 *
 * Determines whether a test location (such as the cursor) is contained within
 * the silhouette of a dark object. 
 */


import processing.video.*;
import controlP5.*;

ControlP5 cp5;
color black = color(0);
color white = color(255,255,255,255);
int sliderValue = 80;
int numPixels;
Capture video;
PImage img;
PImage foregroundImg;
PImage retake;
PImage whiteC;
PImage videoImg = createImage(1231, 790, ARGB);
PImage button;
PImage tempImage;

void setup() {
  size(1231, 790); // Change size to 320 x 240 if too slow at 1024 x 768
  strokeWeight(5);
 
 // SLIDER SETUP
  cp5 = new ControlP5(this);
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("sliderValue")
     .setPosition(0,0)
     .setRange(0,255)
     ;
 // IMAGE BACKGROUND
 img = loadImage("bread.png");
 img.resize(1231, 790);
 
 foregroundImg = loadImage("breadForeground3.png");
 foregroundImg.resize(1231, 790);
 
 retake = loadImage("retake.png");
 retake.resize(1231, 790);
 
 whiteC = loadImage("white_foreground.png");
 whiteC.resize(1231, 790);
// background(img);
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  video.start(); 
  
  numPixels = video.width * video.height;
  smooth();
}

int threshold = 127;
Boolean inside = false;
void update(int x, int y) {
  if(x>480 && y>673 && x< 778 && y< 777)
  {
    inside = true;
  }
  else
  {
    inside = false;
  }
}

Boolean takePicture = false;

void mousePressed() {
if(inside==true && previewingImage==false)
{
  takePicture = true;
  print(takePicture);
imageNo++;
}
else if(inside==true && previewingImage==true)
{
  previewingImage=false;
  
}
}

void mouseReleased() {
 takePicture = false;
print(takePicture); 
}

Boolean previewingImage = false;
int imageNo = 0;
String currentSavedImage = "";

void drawImages(){
 image(videoImg,0,0);
  image(img,0,0);
  blend(videoImg, 0, 0, 1231, 790, 0, 0, 1231, 790, MULTIPLY);
  
  
 if(!takePicture && previewingImage==false )
 {
  image(foregroundImg,0,0);
  if(tempImage!=null) tempImage=null;
 
 }
 else if(takePicture && previewingImage==false)
 {
   image(whiteC,0,0);
   currentSavedImage = "image"+imageNo+".jpg";
   save(currentSavedImage); 
   takePicture = false;
   previewingImage = true;
 }
 else if(previewingImage==true)
 {
 
 if(tempImage==null)
 {
 tempImage = loadImage(currentSavedImage);
 
 tempImage.resize(1231, 790);
 }
 image(tempImage,0,0);
 image(retake,0,0);
 }
 
}

void draw() {
update(mouseX, mouseY);
  int[] brightnessLevel = new int[numPixels];
/**/  if (video.available()) {
    video.read();
    video.loadPixels();
 //   int threshold = 127; // Set the threshold value
    float pixelBrightness; // Declare variable to store a pixel's color
    // Turn each pixel in the video frame black or white depending on its brightness
    //loadPixels();
    for (int i = 0; i < numPixels; i++) {
      
      pixelBrightness = brightness(video.pixels[i]);
     
      if (pixelBrightness > threshold) { // If the pixel is brighter than the
       brightnessLevel[i] = 0x00FFFFFF;
        //videoImg.pixels[i] &= 0xFFFF0000; // threshold value, make it white
      } 
      else { // Otherwise,
      brightnessLevel[i] = 0xFF9b4114;
        //videoImg.pixels[i] = black; // make it black
      }
    }
    // COPY VIDEO PIXELS TO IMAGE
    videoImg.loadPixels();
 //   int threshold = 127; // Set the threshold value
    // Turn each pixel in the video frame black or white depending on its brightness
    //loadPixels();
    for (int i = 0; i < numPixels; i++) {
      
      videoImg.pixels[i] = brightnessLevel[i];
    }
   // background(img);
    videoImg.updatePixels();
   
  }
  drawImages();
  
  threshold = sliderValue;
  
}
