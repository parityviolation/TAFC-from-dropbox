//--------------------------Parameters-----------------------------------
//Buttons
const int pkR = 19; // int5 WORKS
const int pkC = 18; //int6 WORKS
const int pkL = 2; //int1 WORKS
const int spkr = 10;

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



// Internal variables for Task
int state;
boolean valuePkC;
boolean valuePkL;
boolean valuePkR;
boolean valuePkCnow;
boolean valuePkLnow;
boolean valuePkRnow;
unsigned long timePkInC;
unsigned long timePkOutC;
unsigned long timePkInL;
unsigned long timeRewDeliv;
unsigned long timeIti;
String strToPrint;

//ToBeChanged
unsigned long delayTn1Current = 400;
unsigned long delayTn2Current = 1000;
unsigned long timeRewAvail = 10000;
unsigned long delayRew = 500;
unsigned long durSmallRew = 500;
unsigned long durLargeRew = 1000;
unsigned long durIti = 3000;


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
  pinMode(spkr, OUTPUT);
  
//SET DEFAULT
  Serial.begin(115200);
  while(Serial.read() != 115){
  }
  digitalWrite(ledC,LOW);
  digitalWrite(ledL,LOW);
  digitalWrite(ledR,LOW);
  digitalWrite(valvL,LOW);  


   
  state = STATE_0;
  Serial.println(String(state) +'\t' + String(millis()));
}

//----------------------------LOOP-----------------------------------
void loop() {
  updatePokes();
  task();
}

//----------------------------UPDATE POKES-----------------------------------
void updatePokes()
{  
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
            
        state = WAIT_CIN;
        Serial.println(String(state) +'\t' + String(millis())) ;
        Serial.println(String(111) +'\t' +String(delayTn1Current));
        Serial.println(String(112) +'\t' +String(delayTn2Current));
 
    case WAIT_CIN : // waiting
    
    if (valuePkC) {
        timePkInC = millis();
        state = CIN_PRETONE ;
        Serial.println(String(state) +'\t' + String(millis()));

      }
      break;
      
    case CIN_PRETONE:
      
      if (!valuePkC) {
        timePkOutC = millis();
        state = COUT_PRETONE ;
        Serial.println(String(state) +'\t' + String(millis()));

      }
        
       if (millis()-timePkInC > delayTn1Current) {
          
//         if bdebug{
//            digitalWrite(ledC,HIGH);
//            digitalWrite(ledL,HIGH);
//            digitalWrite(ledR,LOW);
//         }
          tone(spkr,6000,80);
          state = CIN_POSTTONE1;
          Serial.println(String(state) +'\t' + String(millis()));
          
      }
      
      
      break;
      
    case CIN_POSTTONE1: // waiting past tone1
    

      if (!valuePkC) {
        timePkOutC = millis();
        state = COUT_POSTTONE1 ;
        Serial.println(String(state) +'\t' + String(millis()));
 
      }
      
      if (millis()-timePkInC > delayTn2Current) {
        digitalWrite(ledC,HIGH);
        digitalWrite(ledL,HIGH);
        digitalWrite(ledR,HIGH);
        tone(spkr,14000,80);

        state = CIN_POSTTONE2;
        Serial.println(String(state) +'\t' + String(millis()));
 
      }
      
      break;
      
    case CIN_POSTTONE2: // waiting past tone2
    
        
      if (!valuePkC) {
        timePkOutC = millis();
        state = COUT_POSTTONE2;
        Serial.println(String(state) +'\t' + String(millis()));
 
      }
      
      break;
      
    case COUT_PRETONE: // waiting for reward poke (no reward available)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,LOW);
      digitalWrite(ledR,LOW);
      
      if (valuePkL) {
        timePkInL = millis();
        state = PREREWARD_NOREWARD;
        Serial.println(String(state) +'\t' + String(millis()));
 
      }
      
      if (millis()-timePkOutC > timeRewAvail) {
        state = ITISTATE;
        timeIti = millis();
        Serial.println(String(state) +'\t' + String(millis()));
        
      }
    
      break;
      
    case COUT_POSTTONE1: // waiting for rew poke (small reward available)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,LOW);
      
      if (valuePkL) {
        timePkInL = millis();
        state = PREREWARD_REWARD;
        Serial.println(String(state) +'\t' + String(millis()));
      }
      
      if (millis()-timePkOutC > timeRewAvail) {
        timeIti = millis();
        state = ITISTATE;
        Serial.println(String(state) +'\t' + String(millis()));
      }
    
      break;

    case COUT_POSTTONE2: // waiting for rew poke (large reward available)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      
      if (valuePkL) {
        timePkInL = millis();
        state = PREREWARD_LARGEREWARD;
        Serial.println(String(state) +'\t' + String(millis()));
      }
      
      if (millis()-timePkOutC > timeRewAvail) {
        timeIti = millis();
        state = ITISTATE;
        Serial.println(String(state) +'\t' + String(millis()));
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
     
    case PREREWARD_REWARD: // reward poked (small reward)
      digitalWrite(ledL,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,LOW);
      
      if (millis()-timePkInL > delayRew) {
        timeRewDeliv = millis();
        state = WATER_L;
        digitalWrite(valvL,HIGH);
        Serial.println(String(state) +'\t' + String(millis()));
      }
      
    case PREREWARD_LARGEREWARD: // reward poked (large reward)
      digitalWrite(ledC,LOW);
      digitalWrite(ledL,HIGH);
      digitalWrite(ledR,HIGH);
      
      if (millis()-timePkInL > delayRew) {
        timeRewDeliv = millis();
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
      
      if (millis()-timeIti > durIti) {
        state = STATE_0;
        Serial.println(String(state) +'\t' + String(millis()));
      }   
    
  } 
}
