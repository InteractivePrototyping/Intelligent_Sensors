import oscP5.*;
OscP5 oscP5;
int currentClass; 
//color col= color(0, 0, 0);
int col=0;
void setup() {
  size(600, 400);
  background(100);
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(100);
  textSize(64);
  noStroke();
  text(currentClass, width/2-20, height/2+150);
  float ran = random(col);
  if (currentClass == 1) {

    fill(120, 255, 20,150);
    ellipse(width/2, height/2, 150, 150);
    //Do something on class 1
  } else if (currentClass == 2) {
 
    fill(130,50,140,150);
    ellipse(width/2, height/2, 150, 150);
    //Do something else on class 2
  } else if (currentClass == 3) {
 
    fill(230, 50, 40,150);
    ellipse(width/2, height/2, 150, 150);
    //Do something else on class 2
  } else if (currentClass == 4) {

    fill(30, 150, 240,150);
    ellipse(width/2, height/2, 150, 150);
    //Do something else on class 2
  } else {

    noFill();
    ellipse(width/2, height/2, 150, 150);
    //Else do this
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
  }
}