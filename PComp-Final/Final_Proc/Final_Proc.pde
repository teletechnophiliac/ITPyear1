/*

  PComp Final - Stitching Stories
  Dec. 2014

  Processing code to run video that will be 
  controlled by the physical controller

*/

import processing.serial.*;
import processing.video.*;
import ddf.minim.*;
            

/*----variables----*/

//serial communication
Serial switchPort;
int[] arrSwitchVals; //values of the the switches
int[] arrKeyboardVals; //Plan B - values taken from keyboard
Movie passiveMovie;
Movie playingMovie;
Minim minim;
AudioPlayer videoSound;
char lastKeyPressed;

//BopItActions
BopItAction[] BIActions;

//timing
float timeElapsed;

/*----functions----*/

/*

  setup()
  
  - load videos
  - setup canvas
  - setup serial reading from Arduino
  - set up variables

*/
void setup()
{
  
  //load the videos
  BIActions = new BopItAction[5];
  BIActions[0] = new BopItAction("push", new Movie(this,"PUSHIT.mov"));
  BIActions[1] = new BopItAction("twist", new Movie(this,"TWISTIT.mov"));
  BIActions[2] = new BopItAction("pull", new Movie(this,"PULLIT.mov")); 
  BIActions[3] = new BopItAction("spin", new Movie(this,"SPINIT.mov"));
  BIActions[4] = new BopItAction("flick", new Movie(this,"FLICKIT.mov")); 
  passiveMovie = new Movie(this, "TWISTIT.MOV");
  playingMovie = passiveMovie;
  
  //setup music
  minim = new Minim(this);
  videoSound = minim.loadFile("Night Lights.mp3");
  
  //set canvas size
  size(displayWidth,displayHeight);
  
  //setup buffer
  switchPort = new Serial(this, "/dev/tty.usbmodemfa131", 9600);
  switchPort.bufferUntil('\n');
  
  //setup switch array - 6 for the action, last one for trigger check
  arrSwitchVals = new int[6];
  arrKeyboardVals = new int[6];
  for(int i = 0; i < 6; i++)
  {
     arrSwitchVals[i] = 0; 
     arrKeyboardVals[i] = 0;
  }
  
  //loop the audio independently of the video
  videoSound.loop();
  
  //play the first video 
  println("intro movie");
  frameRate(24);
  playingMovie.loop();
  timeElapsed = 0.0;
  lastKeyPressed = 'c';
}

/*

  draw()
  
  - display video in window

*/
void draw()
{
 //draw image to pass in movie frames to
 // if changeEvent, call transition function which lasts over 500 milliseconds
 // all transition function does is apply some sort of mask
 imageMode(CENTER);
 image(playingMovie,displayWidth/2,displayHeight/2);
 
}

/*

  movieEvent
  
  Parameter: Movie - video file to read from
  
  -checks if movie is available to read
  
*/
void movieEvent(Movie m)
{
  if(m.available())
  {
     m.read();
  }
}

/*

  clearArray
  
  -clears switch array 
  
*/
void clearArray()
{
  for(int i = 0; i < arrKeyboardVals.length; i++)
  {
     arrKeyboardVals[i] = 0; 
  }
}

/*

  keyPressed
  
  -"Plan B": fake change with keyboard 
  
*/
void keyPressed()
{
  println("key pressed: " + key + " the last key pressed was: " + lastKeyPressed);
  switch(key)
  {
   //Push - purple
   case 'p':
     if(lastKeyPressed != key)
     {
       arrKeyboardVals[0] = 1;
       arrKeyboardVals[5] = 1;
       lastKeyPressed = key;
       movieSwitch(arrKeyboardVals);
       clearArray();
     }
     break;
   //Twist - yellow
   case 'y':
     if(lastKeyPressed != key)
     {
       arrKeyboardVals[1] = 1;
       arrKeyboardVals[5] = 1; 
       lastKeyPressed = key;
       movieSwitch(arrKeyboardVals);
       clearArray();
     }
     break;
   //Pull - blue
   case 'b':
     if(lastKeyPressed != key)
     {
       arrKeyboardVals[2] = 1;
       arrKeyboardVals[5] = 1;
       lastKeyPressed = key;
       movieSwitch(arrKeyboardVals);
       clearArray();
     }
     break;
   //Spin - orange
   case 'o':
     if(lastKeyPressed != key)
     {
       arrKeyboardVals[3] = 1;
       arrKeyboardVals[5] = 1;
       lastKeyPressed = key;
       movieSwitch(arrKeyboardVals);
       clearArray();
     }
     break;
   //Flick - green
   case 'g':
   if(lastKeyPressed != key)
     {
       arrKeyboardVals[4] = 1;
       arrKeyboardVals[5] = 1;
       lastKeyPressed = key;
       movieSwitch(arrKeyboardVals);
       clearArray();
     }
     break;  
   //reset
   case 'r':
     clearArray();
     break;
   //default - ignore all other
   default:
     break;  
  }
}

/*

  serialEvent()
  
  Parameter: Serial - port to read from
  
  - Read in the switch states from the Arduino
  - Convert the new values to the last switch states in arrSwitchVals
  - If a switch value doesn't match, activate that video and change value

*/
void serialEvent (Serial thisPort)
{
  //read input from serial
  String input = trim(thisPort.readString()); //trim eliminates white space at end
  String[] values = split(input, ',');
  Movie tempMovie;
  
  //check to see if the user did an action by comparing
  //the previous
  
  if(input != null)
  {
    println(input);
    //convert read input to ints to compare to last switch values
    int[] arrReadSwitchVals = int (values);
    
    //check if a switch has been activated
    if(arrReadSwitchVals[arrReadSwitchVals.length-1] == 1)
    {
      movieSwitch(arrReadSwitchVals);
      thisPort.write('x'); 
    }//end arrReadSwitchVals[arrReadSwitchVals.length-1] == 1 check 
  }//end input != null check
  else //Plan B
  {
    //check if key has been hit. If it has, switch the movie and reset the array
    if(arrKeyboardVals[arrKeyboardVals.length-1] == 1 & lastKeyPressed != key)
    {
      movieSwitch(arrKeyboardVals);
      lastKeyPressed = key;
      for(int i = 0; i < arrKeyboardVals.length; i++)
      {
         arrKeyboardVals[i] = 0; 
      }
    }
  }
}

/*

  movieSwitch
  
  Parameter: int[] - event handler array
  
  Switch movies

*/ 
void movieSwitch(int[] arrEventHandler)
{
  timeElapsed = playingMovie.time();
  //find which switch has been activated and play that video
  for (int i = 0; i < arrEventHandler.length-1; i++) //switch 2 for arrReadSwitchVals.length
  {
     println("stored switch val: " + arrSwitchVals[i]);
     //check which switch has been activated and make sure it isn't triggered just because the switch was left on for too long
     if(arrSwitchVals[i] != arrEventHandler[i] 
       & arrEventHandler[i] == 1)
     {  
       println("switching movies");
       playingMovie.stop();
       playingMovie = BIActions[i].getMovie();
       println("time elapsed: " + timeElapsed + " movie duration: " + playingMovie.duration());
       println("time started at: " + playingMovie.time());
       frameRate(24);
       playingMovie.loop();
       if(timeElapsed < playingMovie.duration())
         playingMovie.jump(timeElapsed);
       
       println("movie is now " + playingMovie.filename + " and duration is " + playingMovie.duration());   
     } //end if check
     
     arrSwitchVals[i] = arrEventHandler[i];
     println("looped and movie is " + playingMovie.filename); 
     
  } //end for loop
}
