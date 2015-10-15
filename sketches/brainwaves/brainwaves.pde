
import processing.serial.*;
Serial serial;

import arb.soundcipher.*;

SoundCipher scAttention = new SoundCipher(this);
SoundCipher scMeditation = new SoundCipher(this);

int packetCount = 0;
int globalMax = 0;
String scaleMode;
int[] valuesReceived = new int[11];
String[] brainwaveTypes = {"Signal Quality",
  "Attention", 
  "Meditation",
  "Delta",
  "Theta",
  "Low Alpha",
  "High Alpha",
  "Low Beta",
  "High Beta",
  "Low Gamma", 
"High Gamma"};

void setup() {
  // Set up window
  size(1024, 768);
  frameRate(60);
  smooth();
   println(Serial.list());
  serial = new Serial(this, Serial.list()[2], 9600);  
  serial.bufferUntil(10);
  
}

void draw() {
  
}

void serialEvent(Serial p) {
  // Split incoming packet on commas
  // See https://github.com/kitschpatrol/Arduino-Brain-Library/blob/master/README for information on the CSV packet format
  String[] incomingValues = split(p.readString(), ',');

  // Verify that the packet looks legit
  if (incomingValues.length > 1) {
    packetCount++;

    // Wait till the third packet or so to start recording to avoid initialization garbage.
    if (packetCount > 3) {
      //println(incomingValues.length);
      for (int i = 0; i < incomingValues.length; i++) {
        int newValue = Integer.parseInt(incomingValues[i].trim());

        // Zero the EEG power values if we don't have a signal.
        // Can be useful to leave them in for development.
        if ((Integer.parseInt(incomingValues[0]) == 200) && (i > 2)) newValue = 0;

        //channels[i].addDataPoint(newValue);
        valuesReceived[i] = newValue;
       println(brainwaveTypes[i]+": "+newValue);
       playSomeMusic();
      }
    }
  }
  
}

void playSomeMusic()
{
  // CHECK IF THE SIGNAL QUALITY IS ACCEPTABLE
 if(valuesReceived[0]==0) 
 {
   /*
   playNote(double startBeat,
                     double channel,
                     double instrument,
                     double pitch,
                     double dynamic,
                     double duration,
                     double articulation,
                     double pan)
   */
   // piano 18-100
   scAttention.playNote(0.5, 10, 0, map(valuesReceived[1], 18, 100, 0, 100), 100, 4.1, 1.24, 64  );
   scMeditation.playNote(0, 11, 92, map(valuesReceived[2], 18, 100, 0, 100), 100, 4.1, 1.24, 64  );
 }
 else
 {
  println("signal quality not acceptable"); 
 }
}


