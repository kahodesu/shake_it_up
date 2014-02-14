//======LIBRARIES======
import ddf.minim.*; //sound
import processing.serial.*; //serial communications

//======VARIABLES======
int startTime; //to keep shake starting time
int shakeTime; // to keep how long can was shook
int startPlayTime; //to keep start of play time
int playTime; // too keep how long can was played
boolean shakenUp; //to keep whether can had been shaken up

PImage shakeImage;  //images for screen
PImage pickImage; 
PImage winImage;  
PImage loseImage;

Minim minim; //audio class
AudioSample buzzerSound; //audio samples
AudioSample canOpenSound;
AudioSample dingSound;
AudioSample explosionSound;
AudioSample shakeSound;

Serial myPort; //to set up serial port
int val; //what is read over serial communication

//======SET UP -HAPPENS ONCE =====
void setup() {

  size(1280, 768, P2D); //screen size and renderer
  minim = new Minim(this); 

  shakeImage = loadImage("shake.png");  // Load the image into the program  
  pickImage = loadImage("pick.png");
  winImage = loadImage("win.png"); 
  loseImage = loadImage("lose.png");

  canOpenSound = minim.loadSample("canopen.mp3", 512);//load all the sounds
  dingSound = minim.loadSample("dingwin.mp3", 512);
  explosionSound = minim.loadSample("explosion.wav", 512);
  shakeSound = minim.loadSample("shakecan.mp3", 512);

  String portName = Serial.list()[0];//prepare for serial communications
  myPort = new Serial(this, portName, 9600);

  startGame();//for being able to restart
}

//======DRAW - LOOPS FOREVER=====
void draw() {

  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
  }
  if (!shakenUp) { //if the can hasn't been shaken up yet
    if (val == 1) { //the first time it is touched
      //if (keyPressed && key == ' ') {//FOR DEBUGGING
      println("pressed");
      startTime = millis();
      shakeSound.trigger();
    }
    if (val == 2) {//when it is released
      // if (keyPressed && key == '2') {//FOR DEBUGGING
      image(pickImage, 0, 0);
      println("released");
      startPlayTime = millis();
      shakeTime = millis() - startTime;//records how long it's been shaken
      dingSound.trigger();
      shakenUp = true; //it's been shaken up now
    }
  }
  else { //after it's been shaken up
    if (val == 1) { //when it's touched again
      //if (keyPressed && key == '3') {   //FOR DEBUGGING
      playTime = millis() - startPlayTime; //how long it's been left alone before touched
      if (playTime < shakeTime) {   //if you haven't left it alone enough   
        image(loseImage, 0, 0);
        println("lose");
        explosionSound.trigger();//explosion!
      }
      else {// if you've left it alone enough for the bubbles to calm down
        image(winImage, 0, 0);
        println("win");
        canOpenSound.trigger();//then you can drink it, aaaaah!
      }
      delay(5000);
      startGame();
    }
  }
}

void startGame() { // put in a seperate function here so the game can restart
  startTime = 0;
  shakeTime = 0;
  startPlayTime = 0;
  playTime = 0;
  shakenUp = false;
  image(shakeImage, 0, 0);
  println("start");
}

