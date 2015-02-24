/* 1st step towards learning the ...
Interval duration discrimination task
Thiago Gouvea, Learning lab, Aug 2012 */

// Task parameters
int ITI = 15000;
double ITInow;
const int timeValvL = 98*2;                     // Calibrate valves for 2.58 ul with 50
const int timeValvR = 128*2;                 // Calibrate valves for 3.66 ul with 50

// Internal variables
int state;
boolean valuePkC;
boolean valuePkL;
boolean valuePkR;
boolean valuePkCnow;
boolean valuePkLnow;
boolean valuePkRnow;
unsigned long swTrialOn;
int trialNum = 0;

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

void setup() {
  randomSeed(analogRead(0));
  Serial.begin(115200);
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
  
  digitalWrite(valvL,LOW);
  digitalWrite(valvR,LOW);
  

  digitalWrite(syncLed,HIGH);
  delay(500);
  Serial.print(61); Serial.print("\t"); Serial.println(millis());
  digitalWrite(syncLed,LOW);
  delay(50);
  Serial.print(62); Serial.print("\t"); Serial.println(millis());
  digitalWrite(syncLed,HIGH);
  delay(50);
  Serial.print(61); Serial.print("\t"); Serial.println(millis());
  digitalWrite(syncLed,LOW);
  delay(50);
  Serial.print(62); Serial.print("\t"); Serial.println(millis());
  digitalWrite(syncLed,HIGH);
  delay(50);
  Serial.print(61); Serial.print("\t"); Serial.println(millis());
  digitalWrite(syncLed,LOW);
  delay(50);
  Serial.print(62); Serial.print("\t"); Serial.println(millis());
  digitalWrite(syncLed,HIGH);
  delay(200);
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

     ITInow = pow(ITI,pow(.9,random(10)));

     Serial.print(3); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledC,LOW);
     state = 23;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 23: // wait_Cin state
     if (valuePkC) {
       Serial.print(11); Serial.print("\t"); Serial.println(millis());
       digitalWrite(ledC,HIGH);
       swTrialOn = millis();
       state = 25;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
    
    case 25: // wait_Sin state
    
     Serial.print(4); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,LOW);
     Serial.print(5); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,LOW);
     
     if(valuePkL){
         state = 26;
         Serial.print(state); Serial.print("\t"); Serial.println(millis());
         swTrialOn = millis();
     }
     else if(valuePkR){
           state = 28;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
         swTrialOn = millis();
     }
     break;
    
    case 26: // correct_Lin state
     state = 30;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 28: // correct_Rin state
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
    
    case 32: // ITI state
     if((millis()-swTrialOn)>ITInow){
       state = 22;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
  }
}
