Timer timer;
int savedTime; // When Timer started
  int totalTime; // How long Timer should last
int passedTime = 0;


void setup() {
  frameRate(30);
  size(200,200);
  
 /* timer = new Timer(5000);
  timer.start();*/
  String s = "The quick brown fox jumped over the lazy dog.";
fill(50);
savedTime = millis();

}

void draw() {
  background(0xffffff);
  passedTime = millis()- savedTime;
  int mil = passedTime;
  float sec = floor(passedTime*0.001);
  
  text("sec: "+sec+" mil:"+mil, 0,100);
  saveFrame("frames/######.tif");
    // Text wraps within text box
 /* if (timer.isFinished()) {
    background(random(255));
    timer.start();
  }*/
}
