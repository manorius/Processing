/**
 *  blobgons
 *
 *  by Ricard Marxer
 *
 *  This example shows how to create blobgon bodies.
 */

import fisica.*;

FWorld world;
FBlob blob;

void setup() {
  size(1024, 768);
  smooth();

  Fisica.init(this);

  world = new FWorld();
  world.setGravity(0, 800);
  world.setEdges();
  world.remove(world.left);
  world.remove(world.right);
  world.remove(world.top);
  
  world.setEdgesRestitution(0.5);
}

void draw() {
  background(255);

  world.step();
  world.draw(this);  

  // Draw the blobgon while
  // while it is being created
  // and hasn't been added to the
  // world yet
  if (blob != null) {
    blob.draw(this);
  }
}


void mousePressed() {
  if (world.getBody(mouseX, mouseY) != null) {
    return;
  }

  blob = new FBlob();
  blob.setStrokeWeight(3);
  blob.setFill(120, 30, 90);
  blob.setDensity(10);
  blob.setDamping(1800);
  blob.setDensity(1800);
  blob.setRestitution(0.1);
  blob.setFriction(800);
  blob.vertex(mouseX, mouseY);
}

void mouseDragged() {
  if (blob!=null) {
    blob.vertex(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (blob!=null) {
    world.add(blob);
    blob = null;
  }
}

void keyPressed() {
  if (key == BACKSPACE) {
    FBody hovered = world.getBody(mouseX, mouseY);
    if ( hovered != null &&
         hovered.isStatic() == false ) {
      world.remove(hovered);
    }
  } 
  else {
    try {
      saveFrame("screenshot.png");
    } 
    catch (Exception e) {
    }
  }
}




