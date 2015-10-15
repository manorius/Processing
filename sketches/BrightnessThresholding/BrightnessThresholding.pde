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
int sliderValue = 108;
int numPixels;
Capture video;
PImage img;
PImage foregroundImg;
PImage videoImg = createImage(640,480, ARGB);

void setup() {
  size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  strokeWeight(5);
 
 // SLIDER SETUP
  cp5 = new ControlP5(this);
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("sliderValue")
     .setPosition(100,50)
     .setRange(0,255)
     ;
 // IMAGE BACKGROUND
 img = loadImage("bread.jpg");
 img.resize(640,480);
 
 foregroundImg = loadImage("breadForeground.png");
 foregroundImg.resize(640,480);
// background(img);
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  video.start(); 
  
  numPixels = video.width * video.height;
  noCursor();
  smooth();
}
int threshold = 127;
void draw() {
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
  image(videoImg,0,0);
  image(img,0,0);
  blend(videoImg, 0, 0, 640, 480, 0, 0, 640, 480, MULTIPLY);
  
  image(foregroundImg,0,0);
  
  threshold = sliderValue;
  
}
