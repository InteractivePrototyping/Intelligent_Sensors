import oscP5.*;
OscP5 oscP5;
int currentClass; 
PImage[] imgs;
int index = 0;

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);

  imgs = new PImage[4];
  imgs[0] = loadImage("dog.gif");
  imgs[1] = loadImage("cow.gif");
  imgs[2] = loadImage("cobra.gif");
  imgs[3] = loadImage("toad.gif");
}

void draw() {
  background(255);
  image(imgs[index], 0, 0, width, height);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
    index = currentClass - 1;
  }
}