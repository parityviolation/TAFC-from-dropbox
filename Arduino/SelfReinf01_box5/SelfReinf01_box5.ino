/* 1st step towards learning the ...
Interval duration discrimination task
BVA SS, Aug 2012 */

// Task parameters
int ITI = 15000;
double ITInow;
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
int trialNum = 0;

//Stimulation parameters
int pwmPin = 10; // output pin supporting PWM
int rampUPstep = 1;
float amp = 100; // fraction of 100
int pulsewidth = 5; // ms
int pulsefrequency = 50; // Hz
int pulseinterval = 1000/pulsefrequency;
long valPINPWM = 50;
long currentao = valPINPWM;
unsigned long lastStepAt =0; //time
unsigned long lastPulseHigh = 0; // time
int stimulationDuration = 500; //stimulation time in seconds
long rewardStart = 0;

// PinOut
int syncLed = 2;
int spkr = 3;
int pkC = 56;
int ledC = 23;
int pkL = 55;
int ledL = 22;
int valvL = 31;
int pkR = 57;
int ledR = 24;
int valvR = 30;

void setup() {
  Serial.begin(115200);
  
  while(Serial.read() != 115){
  }  
  randomSeed(analogRead(0));
  
  TCCR2B = (TCCR2B & 0xF8) | 0x01; // set Timer 2 to 32kHz (pins 9 and 10) //http://sobisource.com/?p=195
  pinMode(pwmPin, OUTPUT); // sets the pin as output
  analogWrite(pwmPin, 0);
 
  
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
     
//     Serial.print(6); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(valvL,HIGH);
//     delay(timeValvL);
//     Serial.print(14); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(valvL,LOW);
     
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 31: // water_R state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);
     rewardStart = millis();
    
    while(millis()- rewardStart <= stimulationDuration)
    {
    if ((millis()-lastPulseHigh) >= pulseinterval)
      {
      valPINPWM = currentao;
      lastPulseHigh = millis();
      }
      if (valPINPWM>0 && (millis()-lastPulseHigh) >= pulsewidth)
      {currentao = valPINPWM;
      valPINPWM = 0;
      }
  
  
      analogWrite(pwmPin, valPINPWM);
      //Serial.println(valPINPWM);
     }
    analogWrite(pwmPin, 0);
    
//     Serial.print(7); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(valvR,HIGH);
//     delay(timeValvR);
//     Serial.print(15); Serial.print("\t"); Serial.println(millis());
//     digitalWrite(valvR,LOW);
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
