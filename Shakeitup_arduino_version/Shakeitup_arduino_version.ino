#include <CapacitiveSensor.h>

/* This code was made using CapitiveSense Library Demo Sketch - Paul Badger 2008
 * I am using a 10< resistor between pins 2 and 4 with alligator clip on pin 2 side of resistor connected to tab on top of soda can.
 */

//direct contact threshold
int threshold = 10000;
int gameState = 0; //0= game starts, 1 = shake, 2 = shake release/pick it up, 3= picked up
boolean pickedUp = false;
long total1;
CapacitiveSensor   cs_4_2 = CapacitiveSensor(4,2);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired


void setup() {
   cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
   Serial.begin(9600);
}

void loop() {                    
  checkSensor();
  if (!pickedUp && total1 > threshold) { //has to not be picked up yet, and has to be greater than threshold to count as being picked up
    gameState = 1;
    pickedUp = true;
 //  Serial.println(gameState);//FOR DEBUGGING
     Serial.write(gameState); //sending 1 over USB
  }
  else if (pickedUp && total1 <= threshold ) { //must have been picked up already and less than threshold to count as being released
     pickedUp = false;
     gameState = 2;
   //  Serial.println(gameState);//FOR DEBUGGING
     Serial.write(gameState); //sending 2 over USB
  } 
}

void checkSensor () {
  long start = millis();
   total1 =  cs_4_2.capacitiveSensor(30);
//Serial.print(millis() - start);        // check on performance in milliseconds
//Serial.print("\t");                    // tab character for debug windown spacing
//Serial.println(total1);                  // print sensor output 1
//delay(10);                             // arbitrary delay to limit data to serial port 
}
