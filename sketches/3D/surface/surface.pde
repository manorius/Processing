import processing.opengl.*;
import igeo.*;

size( 480, 360, IG.GL );

IVec[][] cpts1 = new IVec[2][2];
cpts1[0][0] = new IVec( 0, 0, 0);
cpts1[1][0] = new IVec(-30, 0, 0);
cpts1[0][1] = new IVec( 0,-30, 0);
cpts1[1][1] = new IVec(-30,-30, 0);
// surface 1 (gray)
new ISurface(cpts1);

IVec[][] cpts2 = new IVec[10][2];
for(int i=0; i < cpts2.length; i++){
  if(i%2==0){
    cpts2[i][0] = new IVec(i*10,0,0);
    cpts2[i][1] = new IVec(i*10,0,20);
  }
  else{
    cpts2[i][0] = new IVec(i*10,-10,0);
    cpts2[i][1] = new IVec(i*10,10,10);
  }
}
// surface 2 (purple)
new ISurface(cpts2).clr(.5,0,1);

IVec[][] cpts3 = new IVec[4][4];
for(int i=0; i < cpts3.length; i++){
  for(int j=0; j < cpts3[i].length; j++){
    if( (i==0||i==3) && (j==1||j==2) ){
      cpts3[i][j] = new IVec(-i*10, j*10, 20);
    }
    else{ cpts3[i][j] = new IVec(-i*10, j*10, 0); }
  }
}
// surface 3 (pink)
new ISurface(cpts3,3,3).clr(1,.5,1);
