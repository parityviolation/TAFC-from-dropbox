/* MATCHINGv07
Matching Task
PHOTOSTIMULUS RAMPS DOWN
PHOTOSTIMULUS ON BOTH HIGH AND LOW PROB SIDES
Learning lab, May 2013 */

// Tweakable parameters

// LATER TRAINNING
int pHi =  40; // 0-100% Higher reward probability
int pLo =  10; // 0-100% Lower reward probability
int blockLenMin = 50;
int blockLenMax = 50; // this + blockLenMin
int ITI = 2000; // (ms)
int choiceDeadline = 3000; // (ms)
int rwdDelay = 0; // (ms)
int timeValvL = 21; // Calibrate valves for 0.8 ul
int timeValvR = 22; // Calibrate valves for 0.8 ul
int laserOnset = 0; // Relative to reward onset
int laserDurSet[] = {500, 1000};  // Duration of laser pulses (square and sustained)
int probStim = 50;  // p(stim), Percentage of photostimulated trials
int tilStim = 10;

// EARLY TRAINNING
//int pHi =  60; // 0-100% Higher reward probability
//int pLo =  10; // 0-100% Lower reward probability
//int blockLenMin = 100;
//int blockLenMax = 100; // this + blockLenMin
//int ITI = 2000; // (ms)
//int choiceDeadline = 3000; // (ms)
//int rwdDelay = 0; // (ms)
//int timeValvL = 21; // Calibrate valves for 2.5 ul
//int timeValvR = 22; // Calibrate valves for 2.5 ul
//int laserOnset = 0; // Relative to reward onset
//int laserDurSet[] = {500, 1000};  // Duration of laser pulses (square and sustained)
//int probStim = 0;  // p(stim), Percentage of photostimulated trials
//int tilStim = 10;

// PinOut
int syncLed = 22;
int spkr = 3;
int pkC = 8;
int ledC = 9;
int pkL = 5;
int ledL = 6;
int valvL = 7;
int pkR = 11;
int ledR = 12;
int valvR = 4;
int laser = 44; //2;
//int aoPIN = 44;

// Internal variables
int dieL;
int dieR;
int state;
int trialNum = 0;
int blockCount = 0;
int trialCount = 0;
int blockLenCurrent = -1;
int laserDur;
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
unsigned long swLaserOn;

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
  pinMode(laser,OUTPUT);

  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,HIGH);
  digitalWrite(syncLed,LOW);
  digitalWrite(valvL,LOW);
  digitalWrite(valvR,LOW);
  analogWrite(laser,0);
  
  Serial.begin(4800);
  while(Serial.read() != 115){
  }
  
  state = 22;
  Serial.println(String(state) + '\t' + String(millis()));
  Serial.println(String(110) + '\t' + String(probStim));
  
  if (random(2)==1) {leftHi = true;
  }
  else {leftHi = false;
  }
 }

void loop() {
  updatePokes();
  stateMachine();  
}

// Read pokes
void updatePokes(){
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
}

// Run state machine
void stateMachine(){
  switch (state) {
    case 22: // state_0 state
    // THis is a hack it is not clear why this timer needs to be reset each time
     TCCR5B = (TCCR5B & 0xF8) | 0x01;                         // set Timer to 32kHz //http://sobisource.com/?p=195

     digitalWrite(syncLed,HIGH);
     Serial.println(String(61) + '\t' + String(millis()));
     delay(100);
     digitalWrite(syncLed,LOW);
     Serial.println(String(62) + '\t' + String(millis()));
     
     trialNum++;
     trialCount++;
     
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
     if(trialNum<tilStim){
       laserDur = 0;
     }
     else{
       if(random(100)<probStim){
         laserDur = laserDurSet[random(sizeof(laserDurSet)/sizeof(int))];
       }
       else{
         laserDur = 0;
       }
     }

     if(leftHi){
       if(rwdL==false){
         dieL = random(100);
         if(dieL<(pHi)){
           rwdL = true;
         }
       }
       if(rwdR==false){
         dieR = random(100);
         if(dieR<(pLo)){
         rwdR = true;
         }
       }
     }
     else{
       if(rwdL==false){
         dieL = random(100);
         if(dieL<(pLo)){
         rwdL = true;
         }
       }
       if(rwdR==false){
         dieR = random(100);
         if(dieR<(pHi)){
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
       digitalWrite(ledC,HIGH);
       Serial.println(String(11) + '\t' + String(millis()));
       digitalWrite(ledL,LOW);
       Serial.println(String(4) + '\t' + String(millis()));
       digitalWrite(ledR,LOW);
       Serial.println(String(5) + '\t' + String(millis()));
       tone(spkr,7000,150);
       state = 25;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
    
    case 25: // wait_Sin state
     if((millis()-swTrialOn)>choiceDeadline){
       state = 40;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     else{
       if(valuePkL){
         if(rwdL == true){
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
    
    case 26: // correct_Lin state
     state = 30;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 27: // unrewarded_Rin state
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 28: // correct_Rin state
     state = 31;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
     
    case 29: // unrewarded_Lin state
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 30: // water_L state
     rwdL = false;
     tone(spkr,7000,150); // comment out
     digitalWrite(valvL,HIGH);
     Serial.println(String(6) + '\t' + String(millis()));
     delay(timeValvL);
     digitalWrite(valvL,LOW);
     Serial.println(String(14) + '\t' + String(millis()));
     swRwdOn = millis();
     if(laserDur>0){
       state = 81;
       Serial.println(String(state) + '\t' + String(millis()));
       break;       
     }
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 31: // water_R state
     rwdR = false;
     tone(spkr,7000,150); // comment out
     digitalWrite(valvR,HIGH);
     Serial.println(String(7) + '\t' + String(millis()));
     delay(timeValvR);
     digitalWrite(valvR,LOW);
     Serial.println(String(15) + '\t' + String(millis()));
     swRwdOn = millis();
     if(laserDur>0){
       state = 81;
       Serial.println(String(state) + '\t' + String(millis()));
       break;       
     }
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 32: // ITI state
     if((millis()-swTrialOn)>ITI){
       state = 22;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
  
    case 40: // choice_miss state
     digitalWrite(ledL,HIGH);
     Serial.println(String(12) + '\t' + String(millis()));
     digitalWrite(ledR,HIGH);
     Serial.println(String(13) + '\t' + String(millis()));
     state = 32;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
     
    case 81: // laser_on state
     if((millis()-swRwdOn)>laserOnset){
       Serial.println(String(105) + '\t' + String(laserDur));
       analogWrite(laser,255);
       swLaserOn = millis();
       Serial.println(String(83) + '\t' + String(swLaserOn));
       state = 82;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
     
    case 82: // laser_off state
     if((millis()-swLaserOn)>(laserDur-50)){ // Ramp duration assumed to be 100ms, as implied in the subtraction laserDur-50 and in increment -2.55
       for(double i=255; i>=0; i-=2.55){
         analogWrite(laser,i);
         delay(1);
         }
       analogWrite(laser,0);
       Serial.println(String(84) + '\t' + String(millis()));
       state = 32;
       Serial.println(String(state) + '\t' + String(millis()));
     }
     break;
  }  
}
