// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// A rectangular box
class CustomShape {

  // We need to keep track of a Body and a width and height
  Body body;
  
  // SHAPE COORDINATES
ArrayList points = new ArrayList();

  // Constructor
  CustomShape(float x, float y,ArrayList p) {
    // Add the box to the box2d world
    points = p;
    makeBody(new Vec2(x, y));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();

///////////
ArrayList ps = new ArrayList();
for(int n=0;n<9;n++)
{
float[] k = {random(50),random(50)};
ps.add(k);
}

for(int n=0;n<ps.size();n++)
{
println(((float[])ps.get(n)));
print("---");
}

Vec2[] vertices = new Vec2[9];

for(int n=0;n<9;n++)
{
  vertices[n] = box2d.coordPixelsToWorld(new Vec2(((float[])ps.get(n))[0], ((float[])ps.get(n))[1]));
}
    

    sd.set(vertices, vertices.length);

///////////////////////////////////////////////////////   
///////////////////////////////////////////////////////   

/*
    Vec2[] vertices = new Vec2[4];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-15, 25));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(15, 0));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(20, -15));
    vertices[3] = box2d.vectorPixelsToWorld(new Vec2(-10, -10));

    sd.set(vertices, vertices.length);
  */  
///////////////////////////////////////////////////////   
    /*
        Vec2[] vertices = new Vec2[points.size()];
     for(int n=0;n<points.size();n++)
{
  // vertex(((float[])points.get(n))[0],((float[])points.get(n))[1]);
   //stroke(#E07000);
   vertices[n] = box2d.coordPixelsToWorld(new Vec2(((float[])points.get(n))[0],((float[])points.get(n))[1]));
   //println( ((float[])points.get(n)) );

}
   
print("----------------"+vertices.length);
    sd.set(vertices, 29);
    */

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    body.createFixture(sd, 1.0);


    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

