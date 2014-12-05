/* 
  
  PComp Final - Stitching Stories
  Dec. 2014

  Arduino code to track switches for the Bop It Controller


*/ 

/*----variables----*/

//pins
int pushPin = 4;
int twistPin = 6;
int pullPin = 8;
int spinPin = 10;
int flickPin = 12;


int ledPin = A5;

/*

  setup()
  
  Start Serial and set pin modes

*/
void setup() 
{
  // initialize the digital pin as an output.
  Serial.begin(9600);
  pinMode(pullPin, INPUT);
  pinMode(twistPin, INPUT);
  pinMode(pushPin, INPUT);
  pinMode(spinPin, INPUT);
  pinMode(flickPin, INPUT);
  pinMode(ledPin, OUTPUT);
}

/*

  loop()
  
  Check for pushbuttons being pushed (pin set to HIGH)
  
*/
void loop() {
  //turn LED on if a push button is pushed
  
   if (digitalRead(pullPin) == HIGH | digitalRead(twistPin) == HIGH
      | digitalRead(pushPin) == HIGH | digitalRead(spinPin) == HIGH
      | digitalRead(flickPin) == HIGH)
   { 
     digitalWrite(ledPin, HIGH);     // turn off the red LED
   }
     
   else 
   {
     digitalWrite(ledPin, LOW);    // turn on the red LED
   }
  
  //print values
   Serial.print(digitalRead(pushPin));
   Serial.print(",");
   Serial.print(digitalRead(twistPin));
   Serial.print(",");
   Serial.print(digitalRead(pullPin));
   Serial.print(",");
   Serial.print(digitalRead(spinPin));
   Serial.print(",");
   Serial.print(digitalRead(flickPin));
   Serial.print(",");
   Serial.println(digitalRead(ledPin));
   
}
