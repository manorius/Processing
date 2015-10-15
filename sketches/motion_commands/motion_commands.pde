import processing.serial.*;

Serial myPort;
ArrayList points;
PVector currentWaypoint;
boolean motionPlanned=false;

void setup()
{  
  //initialize the serial port to talk to the printer
  println(Serial.list());
  myPort=new Serial(this, Serial.list()[5], 115200);
  points=new ArrayList();
  //  myPort.write("G1 X0 Y0 Z10\n");
  delay(1000);
  home();
  points.add(new Point(new PVector(0, 0, 10)));
  points.add(new Point(new PVector(20, 20, 10), true));
  points.add(new Point(new PVector(20, -20, 10), true));
  points.add(new Point(new PVector(-20, -20, 10), true));
  points.add(new Point(new PVector(-20, 20, 10), true));
  points.add(new Point(new PVector(20, 20, 10), true));
  points.add(new Point(new PVector(0, 0, 10), true));
  points.add(new Point(new PVector(0, 0, 60), true));
  points.add(new Point(new PVector(0,0,80)));
  stream();
}

void home()
{
  myPort.write("M107\r\n");
  myPort.write("G28\r\n");
  myPort.write("G90\r\n");
}

void draw()
{
  if(myPort.available()>0)
  {
    String s = myPort.readStringUntil('\n');
    if(s!=null)
    {
    println(s.trim());

    if (s.trim().startsWith("mm")) 
      motionPlanned=true;
    if(motionPlanned)
    if (s.trim().startsWith("ok")) 
    {
      println("moving on to the next command");
      stream();
    }
    if (s.trim().startsWith("error")) stream(); // XXX: really?
    }
  }
}

void stream()
{
  motionPlanned=false;
  if (points.size()>0)
  {
    Point point=(Point)points.get(0);
    println("moving to ("+point.point.x+", "+point.point.y+", "+point.point.z+")");
    if (point.pen)
      myPort.write("M106\r\n");  //turn on the ink
    myPort.write("G1 X"+point.point.x+" Y"+point.point.y+" Z"+point.point.z+"\r\n");  //the actual GCode motion command
    myPort.write("M107\r\n");  //turn off the ink once we're done moving  
    points.remove(0);
  }
}


class Point {
  PVector point;
  boolean pen;
  Point(PVector _point, boolean _pen)
  {
    point=_point;
    pen=_pen;
  }
  Point(PVector _point)
  {
    point=_point;
  }
}

