/**
* Initialises SoundCipher and plays one note.
*
* A SoundCipher library example by Andrew R. Brown
*/

import arb.soundcipher.*;

SoundCipher sc = new SoundCipher(this);
float xoff = 0.0;
float increment = 0.01;

void setup()
{
  frameRate(4);
}
//sc.playNote(60, 100, 2.0);
//sc.playNote(90, 100, 2.0);
void draw()
{
  float value = noise(xoff)*width;
  //
  xoff = xoff + .01;
  //float n = noise(100,30);
  println();
  println(value);
  sc.instrument(45);
  sc.playNote(value, 80, 2.0);
}

