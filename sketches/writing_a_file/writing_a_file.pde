PrintWriter output;

void setup()
{
  size(640, 480);
 output = createWriter("mousePositions.txt"); 
 
}

void draw()
{
  output.println("mouseX:" + mouseX + "mosueY:"+ mouseY);
  
}

void exit() {
  println("exiting");
 key=0;
    output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  super.exit();
}
