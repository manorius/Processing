
boolean defaultRecord = true;

void drawIt(int point,boolean record)
{

 println(record); 
}

void drawIt(int point)
{
  drawIt(point, true);
}


void draw()
{
drawIt(4);
noLoop();
}
