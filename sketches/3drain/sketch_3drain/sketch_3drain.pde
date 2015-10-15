import L3D.*;

L3D cube;
PVector voxel=new PVector(3,3,3);  //this is the voxel that we'll blink

void setup()
{
  frameRate(4);
  size(100, 100, P3D);
  cube=new L3D(this);
  cube.enableDrawing();  //draw the virtual cube
  cube.enableMulticastStreaming();  //stream the data over UDP to any L3D cubes that are listening on the local network
  cube.enablePoseCube();
}

int[] startingXY = {int(random(7)),int(random(7))};
int z = 7;

void draw()
{
   
  background(0);
  cube.background(0);
 // if ((frameCount%20)>10)    //turn the LED on for ten frames, then off for ten frames
    
   // for(int n=0;n<20;n++){
    cube.addVoxel(startingXY[0],z,startingXY[1], color(255,255,255));
    cube.addVoxel(startingXY[0],z+1,startingXY[1], color(255,255,200));
    cube.addVoxel(startingXY[0],z+2,startingXY[1], color(255,255,155));
    z--;
    if(z==0){
      startingXY[0] = int(random(7));
      startingXY[1] = int(random(7));
      z = 7;
    }
    println(z);
   // }
}

