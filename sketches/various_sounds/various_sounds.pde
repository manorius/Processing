// CREATING BEATS
/**
* A drum pattern generator that creates a 4 beat pattern,
* playtes it then generates another 4 beat pattern, and so on.
* SoundCipher's callback facility is used to provide the loop
* regeneration notification at the end of the pattern.
* Simple drawing in time with the music is triggered by callbacks also.
*
* A SoundCipher example by Andrew R. Brown
*/
import controlP5.*;
import arb.soundcipher.*;

ControlP5 cp5;
SCScore score = new SCScore();
int pitch = 0;
int dynamic = 0;
float duration = 0;
float articulation = 0;
int pan = 0;
PrintWriter output;

float startBeat = 0;
int channel = 0;
int instrument = 0;
int tempo = 0;

Knob myKnobA;
Knob myKnobB;
Knob myKnobC;
Knob myKnobD;
Knob myKnobE;

Knob myKnobF;
Knob myKnobG;
Knob myKnobH;

Knob myKnobT;

float[] r = new float[4];

void setup() {  
  size(700,400);
  // READ FILE
  
  String lines[] = loadStrings("instruments.txt");
println("there are " + lines.length + " lines");

  // OVERWRITE FILE
  output = createWriter("instruments.txt"); 
  
  // WRITE PREVIOUS CONTENT
  for (int i =0 ; i < lines.length; i++) {
  println(lines[i]);
  output.println(lines[i]);
}

  smooth();
  noStroke();
  //noLoop();
  cp5 = new ControlP5(this);
  
    cp5.addTextfield("textValue")
     .setPosition(200,170)
     .setSize(200,40)
     .setFont(createFont("arial",20))
     .setAutoClear(false)
     ;
  
  myKnobA = cp5.addKnob("pitch")
               .setRange(0,255)
               .setValue(50)
               .setPosition(40,70)
               .setRadius(30)
               .setDragDirection(Knob.VERTICAL)
               ;
               
   myKnobB = cp5.addKnob("dynamic")
               .setRange(0,255)
               .setValue(100)
               .setPosition(150,70)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;
    myKnobC = cp5.addKnob("duration")
               .setRange(0,4)
               .setValue(0.25)
               .setPosition(250,70)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;
    myKnobD = cp5.addKnob("articulation")
               .setRange(0,4)
               .setValue(0.8)
               .setPosition(350,70)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;
    myKnobE = cp5.addKnob("pan")
               .setRange(0,150)
               .setValue(64)
               .setPosition(450,70)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;    
              
               
        
        myKnobF = cp5.addKnob("startBeat")
               .setRange(0,50)
               .setValue(0)
               .setPosition(100,30)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;   
        myKnobG = cp5.addKnob("channel")
               .setRange(0,50)
               .setValue(9)
               .setPosition(200,30)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;   
        myKnobH = cp5.addKnob("instrument")
               .setRange(0,150)
               .setValue(0)
               .setPosition(300,30)
               .setRadius(10)
               .setDragDirection(Knob.VERTICAL)
               ;       
        
          myKnobT = cp5.addKnob("tempo")
               .setRange(0,255)
               .setValue(112)
               .setPosition(40,140)
               .setRadius(30)
               .setDragDirection(Knob.VERTICAL)
               ;            
               
 // score.tempo(200);
  score.addCallbackListener(this);
  makeMusic();
}

void makeMusic() {
  score.empty();
  score.addNote(startBeat, channel, instrument, pitch, dynamic, duration, articulation, pan);
  score.addCallback(4, 0);
  score.play();
}

void handleCallbacks(int callbackID) {
 score.tempo(tempo);
  score.stop();
  makeMusic();
}
  void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
  //output.println("asdasd");
 
      output.println(theEvent.getStringValue()+" - startbeat: "+startBeat+",channel: "+channel+",instrument: "+instrument+",pitch: "+pitch+",dynamic: "+dynamic+",duration: "+duration+",articulation: "+articulation+", pan: "+ pan);
   println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
}
void draw() {
 // background(120);
 // rect(r[0], r[1], r[2], r[3]);
}

void exit() {
  println("exiting");
   score.stop();
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  super.exit();
}

