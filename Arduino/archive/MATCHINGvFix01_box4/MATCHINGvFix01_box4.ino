/* MATCHINGvFix01
Matching Task, with fixation
NO LASER
Learning lab, Feb 2013 */

// Task parameters
int pHi =  70; // 0-100% Higher reward probability
int pLo =  10; // 0-100% Lower reward probability
int blockLenMin = 50;
int blockLenMax = 10; // this + blockLenMin
int ITI = 2000; // (ms)
int choiceDeadline = 60000; // (ms)
int timeOut = 6000; // (ms)
int rwdDelay = 0; // (ms)
int timeValvL = 60; // Calibrate valves for 2.5 ul
int timeValvR = 60; // Calibrate valves for 2.5 ul
int waitTarget = 10000;// Time (ms) the animal is required to wait at the center poke
int waitMin = 1000;
int wait = waitMin;
int waitIncr = 50;
int waitDecr = 10;
//int laserOnset = 300; // Relative to reward onset
//int laserDurS = 300;  // Short laser stimulation
//int laserDurL = 450; // Long laser stimulation
//int earlyBlock = 20; // Number of trials since block transition until performance stabilizes

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

// Internal variables
int coinL;
int coinR;
int state;
int trialNum = 0;
int blockCount = 0;
int trialCount = 0;
int blockLenCurrent = -1;
//boolean laserOn = false;
boolean leftHi;
boolean rwdL = false;
boolean rwdR = false;
boolean valuePkC;
boolean valuePkL;
boolean valuePkR;
boolean valuePkCnow;
boolean valuePkLnow;
boolean valuePkRnow;
unsigned long swTrialOn;
unsigned long swRwdOn;
unsigned long swPkIn;
unsigned long swError;
//unsigned long swLaserOn;
//String strToPrint = String(state) + '\t' + String(millis());

void setup(){
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
  
  Serial.println(String(70) + '\t' + String(millis()));
  state = 22;
  Serial.println(String(state) + '\t' + String(millis()));
  
  if (random(2)==1) {leftHi = true;
  }
  else {leftHi = false;
  }
 }

void loop() {

  // Read pokes
  valuePkCnow = digitalRead(pkC);
  valuePkLnow = digitalRead(pkL);
  valuePkRnow = digitalRead(pkR);
  if(valuePkC != valuePkCnow){
    if(valuePkCnow){      
      Serial.println(String(0) + '\t' + String(millis()));
    }
    else{
      Serial.println(String(8) + '\t' + String(millis()));
    }
    valuePkC = valuePkCnow;
  }
  if(valuePkL != valuePkLnow){
    if(valuePkLnow){
      Serial.println(String(1) + '\t' + String(millis()));
    }
    else{
      Serial.println(String(9) + '\t' + String(millis()));
    }
    valuePkL = valuePkLnow;
  }
  if(valuePkR != valuePkRnow){
    if(valuePkRnow){
      Serial.println(String(2) + '\t' + String(millis()));
    }
    else{
      Serial.println(String(10) + '\t' + String(millis()));
    }
    valuePkR = valuePkRnow;
  }
    
  // Run state machine
  switch (state) {
    case 22: // state_0 state

     digitalWrite(syncLed,LOW);
     Serial.println(String(61) + '\t' + String(millis()));
     delay(100);
     digitalWrite(syncLed,HIGH);
     Serial.println(String(62) + '\t' + String(millis()));
     
     trialNum++;
     trialCount++;
     
     if(wait>waitTarget){
       wait = waitTarget;
     }
     if(wait<waitMin){
       wait = waitMin;
     }
     
     if(trialCount>blockLenCurrent){
       blockCount++;
       trialCount = 0;
       leftHi = !leftHi;
       rwdL = false;
       rwdR = false;
       if(leftHi == true){
         Serial.println(String(101) + '\t' + String(pHi));
         Serial.println(String(102) + '\t' + String(pLo));
       }
       else{
         Serial.println(String(101) + '\t' + String(pLo));
         Serial.println(String(102) + '\t' + String(pHi));
       }
       blockLenCurrent = blockLenMin + random(blockLenMax+1);
     }

     if(leftHi){
       if(rwdL==false){
         coinL = random(100);
         if(coinL<(pHi)){
           rwdL = true;
         }
       }
       if(rwdR==false){
         coinR = random(100);
         if(coinR<(pLo)){
         rwdR = true;
         }
       }
     }
     else{
       if(rwdL==false){
         coinL = random(100);
         if(coinL<(pLo)){
         rwdL = true;
         }
       }
       if(rwdR==false){
         coinR = random(100);
         if(coinR<(pHi)){
         rwdR = true;
         }
       }
     }
     digitalWrite(ledC,LOW); // turn led on
     Serial.println(String(3) + '\t' + String(millis()));
     state = 23;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 23: // wait_Cin state
     if (valuePkC) {
       swTrialOn = millis();
       swPkIn = swTrialOn;
       tone(spkr,7000,150);
       state = 73;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
     
    case 73: // stay_Cin state
     if((millis()-swPkIn)>wait){
       digitalWrite(ledC,HIGH);
       Serial.println(String(11) + '\t' + String(millis()));
       digitalWrite(ledL,LOW);
       Serial.println(String(4) + '\t' + String(millis()));
       digitalWrite(ledR,LOW);
       Serial.println(String(5) + '\t' + String(millis()));
       tone(spkr,7000,150);
       wait = wait + waitIncr;
       state = 25;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     else{
       if(valuePkC==false){
         wait = wait - waitDecr;
         state = 75;
         Serial.println(String(state) + '\t' + String(millis()));
       }
     }
     break;
    
    case 75: // broke_fixation state
     digitalWrite(ledC,HIGH);
     Serial.println(String(11) + '\t' + String(millis()));
     swError = millis();
     state = 34;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 25: // wait_Sin state
     if((millis()-swTrialOn)>choiceDeadline){
       state = 40;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     else{
       if(valuePkL){
         if(rwdL == true){
           swRwdOn = millis();
           state = 26;
           Serial.println(String(state) + '\t' + String(millis()));
         }
         else{
           state = 29;
           Serial.println(String(state) + '\t' + String(millis()));
         }
         Serial.println(String(12) + '\t' + String(millis()));
         digitalWrite(ledL,HIGH);
         Serial.println(String(13) + '\t' + String(millis()));
         digitalWrite(ledR,HIGH);
       }
       if(valuePkR){
         if(rwdR==true){
           swRwdOn = millis();
           state = 28;
           Serial.println(String(state) + '\t' + String(millis()));
         }
         else{
           state = 27;
           Serial.println(String(state) + '\t' + String(millis()));
         }
         Serial.println(String(12) + '\t' + String(millis()));
         digitalWrite(ledL,HIGH);
         Serial.println(String(13) + '\t' + String(millis()));
         digitalWrite(ledR,HIGH);
       }
     }
     break;
    
    case 26: // rewarded_Lin state
     state = 30;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 27: // unrewarded_Rin state
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 28: // rewarded_Rin state
     state = 31;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
     
    case 29: // unrewarded_Lin state
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 30: // water_L state
     rwdL = false;
//     Serial.println("Food consumed. Left patch empty again.");
     digitalWrite(valvL,HIGH);
     Serial.println(String(6) + '\t' + String(millis()));
     delay(timeValvL);
     digitalWrite(valvL,LOW);
     Serial.println(String(14) + '\t' + String(millis()));
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 31: // water_R state
     rwdR = false;
//     Serial.println("Food consumed. Left patch empty again.");
     digitalWrite(valvR,HIGH);
     Serial.println(String(7) + '\t' + String(millis()));
     delay(timeValvR);
     digitalWrite(valvR,LOW);
     Serial.println(String(15) + '\t' + String(millis()));
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 32: // ITI state
     if((millis()-swTrialOn)>ITI){
       state = 22;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
     
    case 33: // error_timeout state
     if((millis()-swError)>timeOut){
       state = 32;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
     
    case 34: // error_tone state
     digitalWrite(ledL,HIGH);
     Serial.println(String(12) + '\t' + String(millis()));
     digitalWrite(ledR,HIGH);
     Serial.println(String(13) + '\t' + String(millis()));
     Serial.println(String(35) + '\t' + String(millis()));
     while((millis()-swError)<150){
       if (random(2) == 1)
         {digitalWrite(spkr,HIGH);}
       else
         {digitalWrite(spkr,LOW);}
     }
     Serial.println(String(36) + '\t' + String(millis()));
     state = 33;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
  
    case 40: // choice_miss state
     digitalWrite(ledL,HIGH);
     Serial.println(String(12) + '\t' + String(millis()));
     digitalWrite(ledR,HIGH);
     Serial.println(String(13) + '\t' + String(millis()));
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
  }
}
