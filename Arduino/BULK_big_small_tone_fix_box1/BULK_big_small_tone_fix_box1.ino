#include <SoftwareSerial.h>

/* Learning a delay after trial initiation ...
Interval duration discrimination task
Thiago Gouvea, Learning lab, Aug 2012 */

// Task parameters
int waitTimeMax = 2000;
int waitTimeNow = 100;
int increment = 10;
int ITI = 15000;
int timeOut = 12000;
int choiceDeadline = 1000000;
int timeValvL = 40; // Calibrate valves for 2.533 ul with 60
int timeValvR = 65; // Calibrate valves for 2.538 ul with 60
//const int rewardAmount[] =  {1,2};
const int rewardAmount[] =  {2};
int rewardNow = 0;
int rewardCond = 0;
const int sizeRewardAmount = sizeof(rewardAmount)/sizeof(const int);
const int toneDur = 150;
//const int toneFreq[] =  {3000,7000};
const int toneFreq[] =  {7000};

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
int rewardSync = 2;
int trialAvailSync = 45;

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
  pinMode(rewardSync,OUTPUT);
  pinMode(trialAvailSync,OUTPUT);

  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,HIGH);
  digitalWrite(syncLed,HIGH);
  digitalWrite(valvL,LOW);
  digitalWrite(valvR,LOW);
  digitalWrite(rewardSync,LOW);
  digitalWrite(trialAvailSync,LOW);
  
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
     Serial.print(217); Serial.print("\t"); Serial.println(millis());
     digitalWrite(trialAvailSync,HIGH);
     delay(50);
     Serial.print(218); Serial.print("\t"); Serial.println(millis());
     digitalWrite(trialAvailSync,LOW);
     trialNum++;
//     Serial.print(3); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(ledC,LOW);
     if (waitTimeNow>waitTimeMax) {
       waitTimeNow = waitTimeMax;
     }     
       rewardNow = 0;
       rewardCond = random(sizeRewardAmount);
       rewardNow = rewardAmount[rewardCond];
        Serial.print(122); Serial.print("\t"); Serial.println(rewardNow);
       
       state = 25;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
       break;
      
      case 25: // wait_Sin state
       if (valuePkL) {
  //       Serial.print(11); Serial.print("\t"); Serial.println(millis());
  //       digitalWrite(ledC,HIGH);
         swTrialOn = millis();
         state = 56;
         Serial.print(state); Serial.print("\t"); Serial.println(millis());
       }
       break;
      
          case 56: // stim_beep1 state
               Serial.print(16); Serial.print("\t"); Serial.println(millis());
        if(rewardCond==0){     
            
//             unsigned long now = millis();
//             while((millis()-now)<toneDur){
//              if (random(2) == 1)
//              {
//                digitalWrite(spkr,HIGH);
//              }
//              else
//              {
//                digitalWrite(spkr,LOW);
//              }
//            }
           tone(spkr,toneFreq[rewardCond],toneDur);
           Serial.print(19); Serial.print("\t"); Serial.println(millis());
           state = 73;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
           break;
        } 
           
         
       else{
      
       tone(spkr,toneFreq[rewardCond],toneDur);
       Serial.print(19); Serial.print("\t"); Serial.println(millis());
       state = 73;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
       break;
       
       }
       
         case 73: // stay_Cin state
       if((millis()-swTrialOn)>waitTimeNow){
  
//       digitalWrite(ledC,HIGH);
//       Serial.println(String(11) + '\t' + String(millis()));
//       digitalWrite(ledL,LOW);
//       Serial.println(String(4) + '\t' + String(millis()));
//       digitalWrite(ledR,LOW);
//       Serial.println(String(5) + '\t' + String(millis()));
//       Serial.println(String(17) + '\t' + String(millis()));
//       tone(spkr,7000,150);
//       Serial.println(String(20) + '\t' + String(millis()));
       state = 26;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     else{
       if(valuePkL==false){
         state = 38;
         Serial.println(String(state) + '\t' + String(millis()));
       }
     }

   break;
       
  
    case 26: // correct_Lin state
     waitTimeNow  += increment;
     state = 30;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;

    
    case 30: // water_L state
//     Serial.print(12); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(ledL,HIGH);
//     Serial.print(13); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(ledR,HIGH);
     
//     Serial.print(215); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(rewardSync,HIGH);
     Serial.print(6); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvL,HIGH);
     delay(timeValvL*rewardNow);
     Serial.print(14); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvL,LOW);
//     Serial.print(216); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(rewardSync,LOW);
     
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    
    case 38: // premature_left_poke_in state
     swError = millis();
     drawStim = false;
     state = 34;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
  
    case 34: // error_tone state
//     Serial.print(12); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(ledL,HIGH);
//     Serial.print(13); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(ledR,HIGH);
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
    }
   // ------- End of session script, reset the script in arduino board --------
    if(Serial.read() == 113){
      digitalWrite(ledC,HIGH);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      resetFunc();
    }
}
