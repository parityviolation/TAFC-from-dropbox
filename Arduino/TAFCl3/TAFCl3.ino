#include <SoftwareSerial.h>

/* Learning a delay after trial initiation ...
Interval duration discrimination task
Thiago Gouvea, Learning lab, Aug 2012 */

// Task parameters
int bound = 1500;
int ITI = 9000;
int timeOut = 12000;
int choiceDeadline = 10000;
int timeValvL = 80; 
int timeValvR = 80; 

// Internal variables
int state;
boolean valuePkC;
boolean valuePkL;
boolean valuePkR;
boolean valuePkCnow;
boolean valuePkLnow;
boolean valuePkRnow;
unsigned long swTrialOn;
unsigned long swError;
unsigned long swStimOff;
int trialNum = 0;
int stimCurrent = 100;
boolean stimLong;
boolean drawStim;

// PinOut
int syncLed = 2;
int spkr = 3;
int pkC = 8;
int ledC = 9;
int pkL = 5;
int ledL = 6;
int valvL = 7;
int pkR = 11;
int ledR = 12;
int valvR = 4;

// Configure start/end of session
//int incomingByte;
void (* resetFunc) (void)=0; // function to restart the protocol

void setup() {
  pinMode(0,INPUT);
  randomSeed(analogRead(0));
  pinMode(syncLed,OUTPUT);
  pinMode(spkr,OUTPUT);
  pinMode(pkC,INPUT);
  pinMode(ledC,OUTPUT);
  pinMode(pkL,INPUT);
  pinMode(ledL,OUTPUT);
  pinMode(valvL,OUTPUT);
  pinMode(pkR,INPUT);
  pinMode(ledR,OUTPUT);
  pinMode(valvR,OUTPUT);

  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,HIGH);
  digitalWrite(syncLed,HIGH);
  digitalWrite(valvL,LOW);
  digitalWrite(valvR,LOW);
  
  Serial.begin(115200);
  while(Serial.read() != 115){
    }

  state = 22;
  Serial.print(state); Serial.print("\t"); Serial.println(millis());
}

void loop() {

  valuePkCnow = digitalRead(pkC);
  valuePkLnow = digitalRead(pkL);
  valuePkRnow = digitalRead(pkR);
  
  // Read pokes
  if(valuePkC != valuePkCnow){
    if(valuePkCnow){
      Serial.print(0); Serial.print("\t"); Serial.println(millis());
    }
    else{
      Serial.print(8); Serial.print("\t"); Serial.println(millis());
    }
    valuePkC = valuePkCnow;
  }
  if(valuePkL != valuePkLnow){
    if(valuePkLnow){
      Serial.print(1); Serial.print("\t"); Serial.println(millis());
    }
    else{
      Serial.print(9); Serial.print("\t"); Serial.println(millis());
    }
    valuePkL = valuePkLnow;
  }
  if(valuePkR != valuePkRnow){
    if(valuePkRnow){
      Serial.print(2); Serial.print("\t"); Serial.println(millis());
    }
    else{
      Serial.print(10); Serial.print("\t"); Serial.println(millis());
    }
    valuePkR = valuePkRnow;
  }
    
  // Run state machine
  switch (state) {
    
    case 22: // state_0 state
     Serial.print(61); Serial.print("\t"); Serial.println(millis());
     digitalWrite(syncLed,LOW);
     delay(50);
     Serial.print(62); Serial.print("\t"); Serial.println(millis());
     digitalWrite(syncLed,HIGH);
     trialNum++;
     Serial.print(3); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledC,LOW);
     if (stimCurrent>bound) {
       stimCurrent = bound;
     }     
     state = 23;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 23: // wait_Cin state
     if (valuePkC) {
       Serial.print(11); Serial.print("\t"); Serial.println(millis());
       digitalWrite(ledC,HIGH);
       swTrialOn = millis();
       state = 56;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
    
    case 56: // stim_beep1 state
     Serial.print(16); Serial.print("\t"); Serial.println(millis());
     tone(spkr,7000,150);
     // Serial.print(19); Serial.print("\t"); Serial.println(millis());
     state = 57;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 57: // stim_beep2 state
     if((millis()-swTrialOn)>stimCurrent){
       Serial.print(17); Serial.print("\t"); Serial.println(millis());
       tone(spkr,7000,150);
       swStimOff = millis();
       // Serial.print(20); Serial.print("\t"); Serial.println(millis());
       Serial.print(4); Serial.print("\t"); Serial.println(millis());
       digitalWrite(ledL,LOW);
       Serial.print(5); Serial.print("\t"); Serial.println(millis());
       digitalWrite(ledR,LOW);
       state = 25;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     else if(valuePkL){
       state = 38;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     else if(valuePkR){
       state = 39;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
    
    case 25: // wait_Sin state
     if((millis()-swStimOff)>choiceDeadline){
       state = 40;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     else{
       if(valuePkL){
         
         state = 26;
         Serial.print(state); Serial.print("\t"); Serial.println(millis());
       }
       else if(valuePkR){
         state = 28;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
       }
     }
     break;
    
    case 26: // correct_Lin state
     stimCurrent += 10;
     state = 30;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 28: // correct_Rin state
     stimCurrent += 10;
     state = 31;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 30: // water_L state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);
     
     Serial.print(6); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvL,HIGH);
     delay(timeValvL);
     Serial.print(14); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvL,LOW);
     
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 31: // water_R state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);

     Serial.print(7); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvR,HIGH);
     delay(timeValvR);
     Serial.print(15); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvR,LOW);

     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 38: // premature_left_poke_in state
     swError = millis();
     drawStim = false;
     state = 34;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 39: // premature_right_poke_in state
     swError = millis();
     drawStim = false;
     state = 34;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
   
    case 34: // error_tone state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);
     Serial.print(35); Serial.print("\t"); Serial.println(millis());
     while((millis()-swError)<150){
       if (random(2) == 1)
         {digitalWrite(spkr,HIGH);}
       else
         {digitalWrite(spkr,LOW);}
     }
     Serial.print(36); Serial.print("\t"); Serial.println(millis());
     state = 33;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
  
    case 33: // error_timeout state
     if((millis()-swError)>timeOut){
       state = 32;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
 
    case 32: // ITI state
     if((millis()-swTrialOn)>ITI){
       state = 22;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
  
    case 40: // choice_miss state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    }
   // ------- End of session script, reset the script in arduino board --------
    if(Serial.read() == 113){
      digitalWrite(ledC,HIGH);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      resetFunc();
    }
}
