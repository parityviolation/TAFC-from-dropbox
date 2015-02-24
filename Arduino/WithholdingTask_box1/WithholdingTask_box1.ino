//--------------------------Parameters-----------------------------------
//Buttons
const int pkR = 19; // int5 WORKS
const int pkC = 18; //int6 WORKS
const int pkL = 2; //int1 WORKS
const int spkrT = 10;
const int spkrN = 9;

//LEDs
const int ledL = 22;
const int ledR = 26;
const int ledC = 27;
const int valvL = 30;
const int syncLed = 7;

// States
const int STATE_0 = 22;
const int WAIT_CIN = 23;
const int CIN_PRETONE = 88;
const int CIN_POSTTONE1 = 89;
const int CIN_POSTTONE2 = 90;
const int COUT_PRETONE = 91;
const int COUT_POSTTONE1 = 92;
const int COUT_POSTTONE2 = 93;
const int PREREWARD_NOREWARD = 94;
const int PREREWARD_REWARD = 95;
const int PREREWARD_LARGEREWARD = 96;
const int WATER_L = 30;
const int WATERLARGE_L = 97;
const int ITISTATE = 32;
const int WAIT_CIN_BEGINNER = 98;
const int FAKE_POKE = 99;

// Internal variables for Task
int state;
boolean valuePkC;
boolean valuePkL;
boolean valuePkR;
boolean valuePkCnow;
boolean valuePkLnow;
boolean valuePkRnow;
unsigned long timeTrialStart;
unsigned long timePkInC;
unsigned long timePkOutC;
unsigned long timePkInL;
unsigned long timeRewDeliv;
unsigned long timeIti;
String strToPrint;

boolean Beginner = 1;
boolean Adaptive = 1;

//TaskParams
unsigned long freqTn1 = 6000;
unsigned long freqTn2 = 11000;
long delayTn1Current = 1;
long delayTn2Min = 101;
long delayTn2Mean = 101;
unsigned long delayTn2Current;
unsigned long maximumDelayTn1 = 400;
unsigned long maximumDelayTn2Min = 700;
unsigned long timeRewAvail = 20000;
unsigned long delayRew = 500;
unsigned long durSmallRew = 52;
unsigned long durLargeRew = 148;
unsigned long durIti = 3000;

// Variables for Beginner
unsigned long timeToFakePoke = 0;

// Variables for Adaptive On
boolean searchIti;
boolean wasImpatient = false;
boolean wasPatient = false;
boolean rewardFlag = false;
int beginnerCounter = 0;


//----------------------------SETUP-----------------------------------
void setup() {
  //INPUTS
  pinMode(pkC,INPUT);
  pinMode(pkL,INPUT);
  pinMode(pkR,INPUT);
  
  //OUTPUTS
  pinMode(ledC, OUTPUT);
  pinMode(ledL, OUTPUT);
  pinMode(ledR, OUTPUT);
  pinMode(valvL, OUTPUT);
  pinMode(spkrT, OUTPUT);
  pinMode(spkrN, OUTPUT);
  
//SET DEFAULT
  Serial.begin(115200);
  while(Serial.read() != 115){
  }
  digitalWrite(ledC,LOW);
  digitalWrite(ledL,LOW);
  digitalWrite(ledR,LOW);
  digitalWrite(valvL,LOW);  

  randomSeed(analogRead(62));
  
  state = STATE_0;
  Serial.println(String(state) +'\t' + String(millis())) ;

}

//----------------------------LOOP-----------------------------------
void loop() {
  
  updatePokes();
  task();
  
}

//----------------------------UPDATE POKES-----------------------------------
void updatePokes() {
  
  valuePkCnow = digitalRead(pkC);
  valuePkLnow = digitalRead(pkL);
  valuePkRnow = digitalRead(pkR);

  // Read pokes
  if(valuePkC != valuePkCnow){
    if(valuePkCnow){
      strToPrint = String(0) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    else{
      strToPrint = String(8) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    valuePkC = valuePkCnow;
  }
  if(valuePkL != valuePkLnow){
    if(valuePkLnow){
      strToPrint = String(1) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    else{
      strToPrint = String(9) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    valuePkL = valuePkLnow;
  }
  if(valuePkR != valuePkRnow){
    if(valuePkRnow){
      strToPrint = String(2) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    else{
      strToPrint = String(10) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    valuePkR = valuePkRnow;
  }
}

//----------------------------TASK-----------------------------------
void task() {

  switch (state) {
    case STATE_0: // waiting for wait poke
    
      delayTn2Current = -(double(delayTn2Mean - delayTn2Min))*(log(double(random(1000000)+1)/double(1000000))) + delayTn2Min;
      Serial.println(String(111) +'\t' +String(delayTn1Current));
      Serial.println(String(112) +'\t' +String(delayTn2Current));
      Serial.println(String(113) +'\t' +String(delayTn2Min));
      Serial.println(String(114) +'\t' +String(delayTn2Mean));
      Serial.println(String(115) +'\t' +String(beginnerCounter));
      Serial.println(String(116) +'\t' +String(timeToFakePoke));
      
      searchIti = true;
      wasImpatient = false;
      wasPatient = false;
      rewardFlag = false;
      
      if (!Beginner) {
        timeTrialStart = millis();
        state = WAIT_CIN;
        Serial.println(String(state) +'\t' + String(timeTrialStart)) ;
        break;
      }
      else {
        timeTrialStart = millis();
        state = WAIT_CIN_BEGINNER;
        Serial.println(String(state) +'\t' + String(timeTrialStart)) ;
        break;
      }
 
    case WAIT_CIN : // waiting
    
      if (valuePkC) {
        timePkInC = millis();
        wasImpatient = true;
        wasPatient = false;
        state = CIN_PRETONE ;
        Serial.println(String(state) +'\t' + String(timePkInC));

      }
      break;
      
    case CIN_PRETONE:
      if (millis()-timePkInC > delayTn1Current) {
          
//         if bdebug{
//            digitalWrite(ledC,HIGH);
//            digitalWrite(ledL,HIGH);
//            digitalWrite(ledR,LOW);
//         }
          tone(spkrT,freqTn1,80);
          state = CIN_POSTTONE1;
          Serial.println(String(state) +'\t' + String(millis()));
          break;
      }
      
      if (!valuePkC) {
        timePkOutC = millis();
        state = COUT_PRETONE ;
        Serial.println(String(state) +'\t' + String(timePkOutC));
        break;
      }
      
      
      break;
      
    case CIN_POSTTONE1: // waiting past tone1
      
      if (millis()-timePkInC > delayTn2Current) {
//        digitalWrite(ledC,HIGH);
//        digitalWrite(ledL,HIGH);
//        digitalWrite(ledR,HIGH);

        tone(spkrT,freqTn2,80);
        state = CIN_POSTTONE2;
        wasImpatient = false;
        wasPatient = true;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (!valuePkC) {
        timePkOutC = millis();
        state = COUT_POSTTONE1 ;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      break;
      
    case CIN_POSTTONE2: // waiting past tone2
    
        
      if (!valuePkC) {
        timePkOutC = millis();
        state = COUT_POSTTONE2;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      break;
      
    case COUT_PRETONE: // waiting for reward poke (no reward available)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,LOW);
      digitalWrite(ledR,LOW);
      
      if (millis()-timePkOutC > timeRewAvail) {
        state = ITISTATE;
        timeIti = millis();
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (valuePkL) {
        timePkInL = millis();
        state = PREREWARD_NOREWARD;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (valuePkC) {
        if (Beginner) {
          timePkInC = millis();
          wasImpatient = true;
          wasPatient = false;
          state = CIN_PRETONE ;
          Serial.println(String(state) +'\t' + String(timePkInC));
          break;
        }
      }
    
      break;
      
    case COUT_POSTTONE1: // waiting for rew poke (small reward available)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,LOW);
      
      if (millis()-timePkOutC > timeRewAvail) {
        timeIti = millis();
        state = ITISTATE;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (valuePkL) {
        timePkInL = millis();
        state = PREREWARD_REWARD;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (valuePkC) {
        if (Beginner) {
          timePkInC = millis();
          wasImpatient = true;
          wasPatient = false;
          state = CIN_PRETONE ;
          Serial.println(String(state) +'\t' + String(timePkInC));
          break;
        }
      }
    
      break;

    case COUT_POSTTONE2: // waiting for rew poke (large reward available)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      
      if (millis()-timePkOutC > timeRewAvail) {
        timeIti = millis();
        state = ITISTATE;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (valuePkL) {
        timePkInL = millis();
        state = PREREWARD_LARGEREWARD;
        Serial.println(String(state) +'\t' + String(millis()));
        break;
      }
      
      if (valuePkC) {
        if (Beginner) {
          timePkInC = millis();
          wasImpatient = true;
          wasPatient = false;
          state = CIN_PRETONE ;
          Serial.println(String(state) +'\t' + String(timePkInC));
          break;
        }
      }
    
      break; 
 
    case PREREWARD_NOREWARD: // reward poked (no reward)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,LOW);
      digitalWrite(ledR,LOW);
      
      if (millis()-timePkInL > delayRew) {
        state = ITISTATE;
        timeIti = millis();
        Serial.println(String(state) +'\t' + String(millis()));
      }
      break;
     
    case PREREWARD_REWARD: // reward poked (small reward)
      digitalWrite(ledL,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,LOW);
      
      if (millis()-timePkInL > delayRew) {
        timeRewDeliv = millis();
        rewardFlag = true;
        state = WATER_L;
        digitalWrite(valvL,HIGH);
        Serial.println(String(state) +'\t' + String(millis()));
      }
      break;
      
    case PREREWARD_LARGEREWARD: // reward poked (large reward)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      
      if (millis()-timePkInL > delayRew) {
        timeRewDeliv = millis();
        rewardFlag = true;
        state = WATERLARGE_L;
        digitalWrite(valvL,HIGH);
        Serial.println(String(state) +'\t' + String(millis()));
      }
      
      break;
     
     
    case WATER_L: // delivering small reward
      
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,LOW);

      if (millis()-timeRewDeliv > durSmallRew) {
        timeIti = millis();
        state = ITISTATE;
        digitalWrite(valvL,LOW);
        Serial.println(String(state) +'\t' + String(millis()));
      }
 
      break;
  
    case WATERLARGE_L: // delivering large reward
      
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      
      if (millis()-timeRewDeliv > durLargeRew) {
        timeIti = millis();
        state = ITISTATE;
        digitalWrite(valvL,LOW);
        Serial.println(String(state) +'\t' + String(millis()));
      }
 
      break;
   
    case ITISTATE: // iti
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,LOW);
      digitalWrite(ledR,LOW);
      tone(spkrN,random(10000),10);
      
      if (searchIti) { // done only once when you first visit ITI
        if (Adaptive) {
          updateParams();
        }
        searchIti = false;
      }
      
      if (millis()-timeIti > durIti) {
        state = STATE_0;
        Serial.println(String(state) +'\t' + String(millis()));
      }  
      
      break;
    
    // states for beginner  
    case WAIT_CIN_BEGINNER:
    
      if (valuePkC) {
        timePkInC = millis();
        wasImpatient = true;
        wasPatient = false;
        state = CIN_PRETONE ;
        Serial.println(String(state) +'\t' + String(timePkInC));

        break;
      }
      
      if (millis()-timeTrialStart > timeToFakePoke) {
        state = FAKE_POKE;
        Serial.println(String(state) +'\t' + String(millis()));
        
        break;
      }
      
      break;
      
    case FAKE_POKE:
      tone(spkrT,freqTn1,80);
      delay(80);
      tone(spkrT,freqTn2,80);
      
      timePkOutC = millis();
      state = PREREWARD_LARGEREWARD;
      Serial.println(String(state) +'\t' + String(timePkOutC));
      break;
  } 
}

void updateParams() {
  if (!Beginner) {
    if (wasPatient) {
      delayTn2Mean += 10;
    }
    else {  
      delayTn2Mean -= 10;
      delayTn2Mean = max(delayTn2Min+100, delayTn2Mean);
    }
  }
  else {
    //Beginner
    if (wasPatient) {
      delayTn2Mean += 10;
      delayTn2Min += 10;
      delayTn2Min = min(delayTn2Min, maximumDelayTn2Min);
      delayTn1Current += 10;
      delayTn1Current = min(delayTn1Current, maximumDelayTn1);
    }
    else if (wasImpatient){
      delayTn1Current -= 10;
      delayTn1Current = max(delayTn1Current, 1);
      delayTn2Min -= 10;
      delayTn2Min = max(delayTn1Current+100, delayTn2Min);
      delayTn2Mean -= 10;
      delayTn2Mean = max(delayTn1Current+100, delayTn2Mean);
    }
    
    if (rewardFlag) {
      beginnerCounter += 1;
      beginnerCounter = min(beginnerCounter, 80);
    }
    else {
      beginnerCounter -= 1;
      beginnerCounter = max(beginnerCounter, 0);
    }
    
    timeToFakePoke = pow(beginnerCounter/10,3)*1000; // conversion from beginner counter to time to fake poke
    
    
  }
}
