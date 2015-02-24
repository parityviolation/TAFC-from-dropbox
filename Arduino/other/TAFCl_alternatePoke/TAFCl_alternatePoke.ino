/* 2nd step towards learning the ...
Interval duration discrimination task - nose poke center and one port available for reward (random)
Thiago Gouvea, Learning lab, Aug 2012, modified Sofia Soares October 2012 */ 

// Task parameters
int ITI = 15000;
double ITInow;
int choiceDeadline = 5000;
int timeOut = 8000;
int timeValvL = 200; // Calibrate valves for 24 ul for t = 100
int timeValvR = 200; // Calibrate valves for 24 ul for t = 100
int min = 0; // lower boundary for rewardSide
int max = 101; // upper boundary for rewardSide

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
long rewardSide;
unsigned long swError;

// PinOut
int syncLed = 2;
int spkr = 3;
int pkC = 8;
int ledC = 9;
int pkL = 5;
int ledL = 6;
int valvL = 13;
int pkR = 11;
int ledR = 12;
int valvR = 7;

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
     rewardSide = random(min, max);

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
      if((millis()-swTrialOn)>choiceDeadline){ // missed trial
       state = 40; 
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     } 

    else{
       if(rewardSide>=(max/2)){ // left side on
         Serial.print(4); Serial.print("\t"); Serial.println(millis());
         digitalWrite(ledL,LOW);

          if(valuePkL){ //correct side
           state = 26;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
         }
         else if(valuePkR){ //incorrect side
           state = 27;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
         }
       }
       else{ // right side on
         Serial.print(5); Serial.print("\t"); Serial.println(millis());
         digitalWrite(ledR,LOW);
         
         if(valuePkL){ //incorrect side
           state = 29;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
         }
         else if(valuePkR){ //correct side
           state = 28;
           Serial.print(state); Serial.print("\t"); Serial.println(millis());
         }
       }
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
     //Serial.print(13); Serial.print("\t"); Serial.println(millis());
     //digitalWrite(ledR,HIGH);
     
     Serial.print(6); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvL,HIGH);
     delay(timeValvL);
     Serial.print(14); Serial.print("\t"); Serial.println(millis());
     digitalWrite(valvL,LOW);
     
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 31: // water_R state
     //Serial.print(12); Serial.print("\t"); Serial.println(millis());
     //digitalWrite(ledL,HIGH);
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
    
    case 27: // error_Rin state
     //Serial.print(12); Serial.print("\t"); Serial.println(millis());
     //digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);
     swError = millis();
     state = 33;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 29: // error_Lin state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     //Serial.print(13); Serial.print("\t"); Serial.println(millis());
     //digitalWrite(ledR,HIGH);
     swError = millis();
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
     if((millis()-swTrialOn)>ITInow){
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
}
