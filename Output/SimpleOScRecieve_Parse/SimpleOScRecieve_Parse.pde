
import oscP5.*;


OscP5 oscP5;

float x,y,z;
float lx, ly,lz;

void setup() {
  size(800, 800, P3D);
  //frameRate(25);
  /* start oscP5, listening for incoming messages at port 6448 */
  
  //direct from Input code use port 6448
  oscP5 = new OscP5(this, 6448);
  //if coming from Wekinator change port to 12000
  //oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0); 
  fill(255,0,0);
 
  translate(width/2,height/2);
  //slow down
  lx=lerp(lx,x,0.1);
  ly=lerp(ly,y,0.1);
  lz=lerp(lz,z,0.1);
  //map
  float mx= map(x,0,1,0,180);
  float my= map(y,0,1,0,180);
  float mz= map(z,0,1,0,180);
  //move
  rotateX(radians(-mx));
  rotateY(radians(my));
  rotateZ(radians(mz));
  box(100,200,500);
}





void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */

  if (theOscMessage.checkAddrPattern("/pose/orientation")==true) {

    x = theOscMessage.get(0).floatValue();  
    y = theOscMessage.get(1).floatValue();
    z = theOscMessage.get(2).floatValue();
    print("### received an osc message /test with typetag fff.");
    println(" values: "+x+", "+y+", "+z);
    return;
  } 
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}