//
//Adapted from rebecka fiebrink Leap Motion 15 inputs example. https://github.com/fiebrink1/wekinator_examples/tree/master/inputs/LeapMotion
//17 inputs sends to port 6448 using /wel/inputs message
//

import oscP5.*;
import netP5.*;
import processing.opengl.*;
int num=0;
int numFound = 0;
int frame=0;
OscP5 oscP5;
NetAddress dest;

import de.voidplus.myo.*;

Myo myo;
ArrayList<ArrayList<Integer>> sensors;

//println("data"+ data[2]);


int  xPos=1;

float[] data;
float[] features = new float[17];
PVector orientation;
PVector accelerometer;
PVector gyroscope;
float lastdata;
float xmag, ymag = 0;
float newXmag, newYmag = 0; 


void setup() {
  size(800, 400, P3D);
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
  background(255);

  stroke(0);
  // ...

  // myo = new Myo(this); //disable EMG data
  myo = new Myo(this, true); // enable EMG data

  sensors = new ArrayList<ArrayList<Integer>>();
  for (int i=0; i<8; i++) {
    sensors.add(new ArrayList<Integer>());
  }
}

void draw() {
  numFound = 0;
  orientation = myo.getOrientation();
  accelerometer = myo.getAccelerometer();
  gyroscope = myo.getGyroscope();
  data = float(myo.getEmg());

  if (frame %3==0) {
    background(255);
    numFound++;
    if (data !=null) {  
      fill(0);
      stroke(0);
      text("Sending 17 inputs of the Myo to Wekinator", 10, 180);
      text("EMG inputs 1-8", 10, 200);
      text("EMG[0]=" + data[0] + ", EMG[1]=" + data[1] + ",EMG[2]=" + data[2] + ",EMG[3]=" + data[3] + ",EMG[4]=" + data[4] + ",EMG[5]=" + data[5]+ ",EMG[6]=" + data[6]+ ",EMG[7]=" + data[7], 10, 220);
      data[0]=features[0];
      data[1]=features[1];
      data[2]=features[2];
      data[3]=features[3];
      data[4]=features[4];
      data[5]=features[5];
      data[6]=features[6];
      data[7]=features[7];
      
//EMG visual 
      for (int i = 0; i<data.length; i++) {
        fill(255, 0, 0, 200);
        noStroke();
        println(map(data[i], -128, 127, 0, 50)); // [-128 - 127] 
        rect(40 +(i*50), 60, 30, data[i]);
      }
    }

    if (orientation !=null) {
      orientation.x = lerp(orientation.x, 0.90, 0.55);
      orientation.y = lerp(orientation.y, 0.90, 0.5);
      orientation.z = lerp(orientation.z, 0.90, 0.5);
      features[8] = orientation.x;
      features[9] = orientation.y;
      features[10] = orientation.z;

      fill(0);
      stroke(0);
      text("Orientation inputs 9-11", 10, 250);
      text("x=" + orientation.x + ", y=" + orientation.y + ", z=" + orientation.z, 10, 270);

      if (accelerometer !=null) { 
        accelerometer.x = lerp(accelerometer.x, 0.90, 0.05);
        accelerometer.y = lerp(accelerometer.y, 0.90, 0.05);
        accelerometer.z = lerp(accelerometer.z, 0.90, 0.05);
        features[11] = accelerometer.x;
        features[12] = accelerometer.y;
        features[13] = accelerometer.z;
        fill(0);
        stroke(0);
        text("Accelerometer inputs 12-14", 10, 300);
        text("x=" + accelerometer.x + ", y=" + accelerometer.y + ", z=" + accelerometer.y, 10, 320);

        if (gyroscope !=null) { 
          gyroscope.x = lerp(gyroscope.x, 0.90, 0.05);
          gyroscope.y = lerp(gyroscope.y, 0.90, 0.05);
          gyroscope.z = lerp(gyroscope.z, 0.90, 0.05);
          features[14] = gyroscope.x;
          features[15] = gyroscope.y;
          features[16] = gyroscope.z;
          fill(0);
          stroke(0);
          text("Gyroscope inputs 15-17", 10, 350);
          text("x=" + gyroscope.x + ", y=" + gyroscope.y + ", z=" + gyroscope.z, 10, 370);

          //Gyro Rotate Box Visual
          pushMatrix(); 
          translate(width/2, height/2, -30); 
          float scaleX= map(gyroscope.x, -0.6, 0.6, 0.0, width); 
          float scaleY= map(gyroscope.y, -0.6, 0.6, 0.0, width);

          newXmag = gyroscope.x/float(width) * TWO_PI;
          newYmag = gyroscope.y/float(height) * TWO_PI;

          float diff = xmag-newXmag;
          if (abs(diff) >  0.01) { 
            xmag -= diff/4.0;
          }

          diff = ymag-newYmag;
          if (abs(diff) >  0.01) { 
            ymag -= diff/4.0;
          }

          rotateX(-ymag); 
          rotateY(-xmag); 

          scale(90);
          beginShape(QUADS);

          fill(0, 1, 1); 
          vertex(-1, 1, 1);
          fill(1, 1, 1); 
          vertex( 1, 1, 1);
          fill(1, 0, 1); 
          vertex( 1, -1, 1);
          fill(0, 0, 1); 
          vertex(-1, -1, 1);

          fill(1, 1, 1); 
          vertex( 1, 1, 1);
          fill(1, 1, 0); 
          vertex( 1, 1, -1);
          fill(1, 0, 0); 
          vertex( 1, -1, -1);
          fill(1, 0, 1); 
          vertex( 1, -1, 1);

          fill(1, 1, 0); 
          vertex( 1, 1, -1);
          fill(0, 1, 0); 
          vertex(-1, 1, -1);
          fill(0, 0, 0); 
          vertex(-1, -1, -1);
          fill(1, 0, 0); 
          vertex( 1, -1, -1);

          fill(0, 1, 0); 
          vertex(-1, 1, -1);
          fill(0, 1, 1); 
          vertex(-1, 1, 1);
          fill(0, 0, 1); 
          vertex(-1, -1, 1);
          fill(0, 0, 0); 
          vertex(-1, -1, -1);

          fill(0, 1, 0); 
          vertex(-1, 1, -1);
          fill(1, 1, 0); 
          vertex( 1, 1, -1);
          fill(1, 1, 1); 
          vertex( 1, 1, 1);
          fill(0, 1, 1); 
          vertex(-1, 1, 1);

          fill(0, 0, 0); 
          vertex(-1, -1, -1);
          fill(1, 0, 0); 
          vertex( 1, -1, -1);
          fill(1, 0, 1); 
          vertex( 1, -1, 1);
          fill(0, 0, 1); 
          vertex(-1, -1, 1);

          endShape();

          popMatrix();
        }
      }
    }
  }
  frame++;

  // =========== OSC ============
  if (num % 3 == 0) {
    sendOsc();
  }
  num++;
}



// ----------------------------------------------------------
void sendOsc() {



  OscMessage msg = new OscMessage("/wek/inputs");

  if (numFound > 0) {
    for (int i = 0; i < features.length; i++) {
      msg.add(features[i]);
    }
  } else {
    for (int i = 0; i < features.length; i++) {
      msg.add(0.);
    }
  }
  oscP5.send(msg, dest);
}

//void dataSetup() {
//  numFound = 0;

//  //
//  //for Orientation
//  //
//  PVector orientation = myo.getOrientation();
//  println("orientation.x" + orientation.x);
//  msg.add((float)orientation.x);
//  msg.add((float)orientation.y);
//  msg.add((float)orientation.z);
//  //  msg.add((float)orientation.w);

//  //
//  //for Acceleration
//  //
//  PVector accelerometer = myo.getAccelerometer();
//  println("accel.x" + orientation.x);
//  msg.add((float)accelerometer.x);
//  msg.add((float)accelerometer.y);
//  msg.add((float)accelerometer.z);
//  //
//  //for Gyroscope
//  //
//  PVector gyroscope = myo.getGyroscope();
//  println("gyro.x" + orientation.x);
//  msg.add((float)gyroscope.x);
//  msg.add((float)gyroscope.y);
//  msg.add((float)gyroscope.z);

//  //
//  //for EMG
//  //
//  int[] data = myo.getEmg();
//  println("data"+ data[0]);
//  msg.add((float)data[0]);
//  msg.add((float)data[1]);
//  msg.add((float)data[2]);
//  msg.add((float)data[3]);
//  msg.add((float)data[4]);
//  msg.add((float)data[5]);
//  msg.add((float)data[6]);
//  msg.add((float)data[7]);
//}

// ----------------------------------------------------------




// ==========================================================
// Executable commands:

void mousePressed() {
  if (myo.hasDevices()) {
    myo.vibrate();
    myo.requestRssi();
    myo.requestBatteryLevel();
  }
}

// ==========================================================
// Application lifecycle:

void myoOnPair(Device myo, long timestamp) {
  println("Sketch: myoOnPair() has been called"); 
  int deviceId             = myo.getId();
  int deviceBatteryLevel   = myo.getBatteryLevel();
  int deviceRssi           = myo.getRssi();
  String deviceFirmware    = myo.getFirmware();
}
void myoOnUnpair(Device myo, long timestamp) {
  println("Sketch: myoOnUnpair() has been called");
}

void myoOnConnect(Device myo, long timestamp) {
  println("Sketch: myoOnConnect() has been called");
  int deviceId             = myo.getId();
  int deviceBatteryLevel   = myo.getBatteryLevel();
  int deviceRssi           = myo.getRssi();
  String deviceFirmware    = myo.getFirmware();
}
void myoOnDisconnect(Device myo, long timestamp) {
  println("Sketch: myoOnDisconnect() has been called");
}

void myoOnWarmupCompleted(Device myo, long timestamp) {
  println("Sketch: myoOnWarmupCompleted() has been called");
}

void myoOnArmSync(Device myo, long timestamp, Arm arm) {
  println("Sketch: myoOnArmSync() has been called");

  switch (arm.getType()) {
  case LEFT:
    println("Left arm");
    break;
  case RIGHT:
    println("Right arm");
    break;
  default:
    println("Unknown arm");
    break;
  }
}

void myoOnArmUnsync(Device myo, long timestamp) {
  println("Sketch: myoOnArmUnsync()");
}

void myoOnLock(Device myo, long timestamp) {
  println("Sketch: myoOnLock() has been called");
}

void myoOnUnLock(Device myo, long timestamp) {
  println("Sketch: myoOnUnLock() has been called");
}




// ----------------------------------------------------------
// Additional information:

void myoOnRssi(Device myo, long timestamp, int rssi) {
  println("Sketch: myoOnRssi() has been called, rssi: " + rssi);
}

void myoOnBatteryLevelReceived(Device myo, long timestamp, int batteryLevel) {
  println("Sketch: myoOnBatteryLevel() has been called, batteryLevel: " + batteryLevel);
} 