/* Simple example of Processing controlling DMX devices
 
 We are sending data from Processing to the Arduino DMX controller. So you will need to run the Arduino code at the end of this program to get this to work.
 
 DMX setup: A lamp responding to data on DMX channels 1 and 2
 
 Arduino setup: Attach Tinker.it! DMX shield Load File > Sketchbook > Examples > Library-DmxSimple > SerialToDmx
 
 by Peter Knight http://www.tinker.it 05 Mar 2009 */

import processing.serial.*; // Import Serial library to talk to Arduino 
//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;


int value1; // create a variable to hold the data we are sending to the Arduino 
int value2; 
Serial myPort; // Send new DMX channel value to Arduino // 

float p1, p2, p3;

void setup() { 
  printArray(Serial.list()); // shows available serial ports on the system 
  // Change 0 to select the appropriate port as required.

  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)


  String portName = Serial.list()[2]; 
  myPort = new Serial(this, portName, 9600);
  size(256, 256); // Create a window

  //some lights need a preset value such as shutter open in the setup in order to work
  setDmxChannel(19, 255); // Send new channel values to Arduino 
  //setDmxChannel(1, 49); // Send new channel values to Arduino 
  setDmxChannel(1, 70); // Send new channel values to Arduino 
  setDmxChannel(3, 60); // Send new channel values to Arduino
}

void draw() {
  fill(0, 255, 0);
  text( "Use 3 continuous Wekinator outputs between 0 and 1", 5, 15 );
  text( "Listening for /wek/outputs on port 12000", 5, 30 );

  setUpDMX(p1, p2, p3);
} 

void setUpDMX(float p1, float p2, float p3) {

  //might need trial and error ad manual reference to double check DMX light channels and values.

  //value1 = (237); // Use cursor X position to get channel 1 value 
  //value2 = (255);// Use cursor Y position to get channel 2 value 

  ////setDmxChannel(1, 49); // Send new channel values to Arduino 
  ////setDmxChannel(1, 237); // Send new channel values to Arduino 
  //setDmxChannel(2, value2); 

  //example structure for OSC inputs.

  float p1new= map(p1, 0.0, 1.0, 0.0, 105.0);
  //might need lerping smoothing
  p1new = lerp(p1new, 0.90, 0.05);
  setDmxChannel(1, int(p1new));

  float p2new= map(p2, 0.0, 1.0, 0.0, 255.0);
  p2new = lerp(p2new, 0.90, 0.05);
  setDmxChannel(9, int(p2new));

//  float p3new= map(p3, 0.0, 1.0, 0, 255);
//  p3new = lerp(p3new, 0.90, 0.05);
//  setDmxChannel(16, p3new);

  // You may have to set other channels. Some lamps have a shutter channel that should be set to 255. 
  // Set it here: setDmxChannel(4,255);

  delay(20); // Short pause before repeating
}

void setDmxChannel(int channel, int value) { // Convert the parameters into a message of the form: 123c45w where 123 is the channel and 45 is the value // then send to the Arduino 
  myPort.write( str(channel) + "c" + str(value) + "w" );
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    if (theOscMessage.checkTypetag("fff")) { //Now looking for 2 parameters
      p1 = theOscMessage.get(0).floatValue(); //get this parameter
      p2 = theOscMessage.get(1).floatValue(); //get 2nd parameter
      p3 = theOscMessage.get(2).floatValue(); //get third parameters


      //update p1, p2, p3 to DMX values in draw  
      setUpDMX(p1, p2, p3);

      println("Received new params value from Wekinator");
    } else {
      println("Error: unexpected params type tag received by Processing");
    }
  }
}