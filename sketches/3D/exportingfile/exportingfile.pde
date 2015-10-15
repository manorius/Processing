import processing.opengl.*;
import igeo.*;

size( 480, 360, IG.GL );

IVec[][] cpts1 = new IVec[10][10];

for(int i=0; i < cpts1.length; i++){
  for(int j=0; j < cpts1[i].length; j++){
    if( (i+j)%2==0 ){ 
      cpts1[i][j] = new IVec(i*5, -j*5-30, (i+j)*2); 
    }
    else{ cpts1[i][j] = new IVec(i*5, -j*5-30, (i+j-1)*2); }
  }
}
// mesh 1 (cyan)
new IMesh(cpts1).clr(0,1.,1.);

int divNum=30;
IVec[][] cpts2 = new IVec[10][divNum+1];
for(int i=0; i < cpts2.length; i++){
  for(int j=0; j < cpts2[i].length; j++){
    float radius = 30 - i*3;
    float angle = 2 * PI / divNum * j;
    cpts2[i][j] = 
      new IVec(cos(angle)*radius, sin(angle)*radius, i*i*.5);
  }
}
// mesh 2 (red)
new IMesh(cpts2).clr(1.,0,0);

IG.save("test_output_file.obj");

