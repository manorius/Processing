


import arb.soundcipher.*;

SoundCipher sc = new SoundCipher(this);

int sampleLength = 20;
Boolean realHeart = false;
int sampleCounter = 0;
int[] values = new int[sampleLength];

void serialEvent(Serial port){ 
   String inData = port.readStringUntil('\n');
   inData = trim(inData);                 // cut off white space (carriage return)
   if (inData.charAt(0) == 'S'){          // leading 'S' for sensor data
     inData = inData.substring(1);        // cut off the leading 'S'
     Sensor = int(inData);                // convert the string to usable int
     println(int(inData));
    
    // TAKE A SAMPLE OF 20 VALUES
    values[sampleCounter] = Sensor;
    
   }
   if (inData.charAt(0) == 'B'){          // leading 'B' for BPM data
     inData = inData.substring(1);        // cut off the leading 'B'
     BPM = int(inData);                   // convert the string to usable int
     beat = true;                         // set beat flag to advance heart rate graph
     heart = 20; 
    // println(BPM);
//sc.playNote(0.0,10,47,15,251,4.0,3.4,64);     // begin heart image 'swell' timer 

   }
 if (inData.charAt(0) == 'Q'){            // leading 'Q' means HRV data 
     inData = inData.substring(1);        // cut off the leading 'Q'
     HRV = int(inData);                   // convert the string to usable int
   }
   
  // sampleCounter = ()? 0:sampleCounter+1;
   if(sampleCounter == sampleLength)
   {
    /*for (int i=0; i < sampleLength; i++) {         
  
}*/
sampleCounter=0;
   }
   else
   {
    sampleCounter++; 
   }
}
