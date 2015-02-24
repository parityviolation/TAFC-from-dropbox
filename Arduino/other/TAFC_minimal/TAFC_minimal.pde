/* Interval duration discrimination task
Thiago Gouvea, Learning lab, Aug 2012 */

// Task parameters
int stimSet[] = {600, 2400};

// Internal variables
int state;
unsigned long swTrialOn;
unsigned long swError;
unsigned long swStimOff;
int trialNum = 0;
int stimCurrent;
String trialData;
boolean stimLong;
int bound = 1500;
int ITI = 9000;
int timeOut = 9000;
int choiceDeadline = 5000;
int timeValvL = 100; // Calibrate valves for 24 ul
int timeValvR = 100; // Calibrate valves for 24 ul
boolean valuePkC;
boolean valuePkL;
boolean valuePkR;

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
int valvR = 13;

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
  /* // Generating stimulus vector
  for(int i = 0; i < 1000; i++){
    stimVector[i] = stimSet[random(8)];
  }
  digitalWrite(syncLed,HIGH);
  delay(50);
  digitalWrite(syncLed,LOW);
  delay(50);
  digitalWrite(syncLed,HIGH);
  delay(50);
  digitalWrite(syncLed,LOW);
  delay(50);
  digitalWrite(syncLed,HIGH);
  delay(50);
  digitalWrite(syncLed,LOW);*/
  trialData = trialData + "22" +"\t" + char(millis()) + "\n";
  state = 22;
}

void loop() {
/*  // Delete the line below
  Serial.println(state); */
  
  // Read pokes
  if(valuePkC != digitalRead(pkC)){
    if(digitalRead(pkC)){
      trialData = trialData + "0" +"\t" + char(millis()) + "\n";
    }
    else{trialData = trialData + "8" +"\t" + char(millis()) + "\n";
    }
    valuePkC = digitalRead(pkC);
  }
  if(valuePkL != digitalRead(pkL)){
    if(digitalRead(pkL)){
      trialData = trialData + "1\t" + millis() + "\n";
    }
    else{
      trialData = trialData + "9\t" + millis() + "\n";
    }
    valuePkL = digitalRead(pkL);
  }
  if(valuePkR != digitalRead(pkR)){
    if(digitalRead(pkR)){
      trialData = trialData + "2\t" + millis() + "\n";
    }
    else{
      trialData = trialData + "10\t" + millis() + "\n";
    }
    valuePkR = digitalRead(pkR);
  }
    
  // Run state machine
  switch (state) {
    case 22: // state_0 state
     digitalWrite(syncLed,LOW);
     delay(50);
     digitalWrite(syncLed,HIGH);
     Serial.print(trialData);
     trialData = "\n";
     trialNum++;
     stimCurrent = stimSet[random(2)];
     stimLong = (stimCurrent > bound);
     digitalWrite(ledC,LOW);
     trialData = trialData + "23\t" + millis() + "\n";
     state = 23;
     break;
    case 23: // wait_Cin state
     if (valuePkC) {
       digitalWrite(ledC,HIGH);
       swTrialOn = millis();
       trialData = trialData + "56\t" + millis() + "\n";
       state = 56;
     }
     break;
    case 56: // stim_beep1 state
     tone(spkr,10000,300);
     trialData = trialData + "57\t" + millis() + "\n";
     state = 57;
     break;
    case 57: // stim_beep2 state
     if((millis()-swTrialOn)>stimCurrent){
       tone(spkr,10000,300);
       digitalWrite(ledL,LOW);
       digitalWrite(ledR,LOW);
       trialData = trialData + "25\t" + millis() + "\n";
       state = 25;
     }
     else if(valuePkL){
       trialData = trialData + "38\t" + millis() + "\n";
       state = 38;
     }
     else if(valuePkR){
       trialData = trialData + "39\t" + millis() + "\n";
       state = 39;
     }
     break;
    case 25: // wait_Sin state
     if((millis()-swStimOff)>choiceDeadline){
       trialData = trialData + "40\t" + millis() + "\n";
       state = 40;
     }
     else{
       if(stimLong){
         if(valuePkL){
           trialData = trialData + "26\t" + millis() + "\n";
           state = 26;
         }
         else if(valuePkR){
           trialData = trialData + "27\t" + millis() + "\n";
           state = 27;
         }
       }
       else{
         if(valuePkL){
           trialData = trialData + "29\t" + millis() + "\n";
           state = 29;
         }
         else if(valuePkR){
           trialData = trialData + "28\t" + millis() + "\n";
           state = 28;
         }
       }
     }
     break;
    case 26: // correct_Lin state
     trialData = trialData + "30\t" + millis() + "\n";
     state = 30;
     break;
    case 28: // correct_Rin state
     trialData = trialData + "31\t" + millis() + "\n";
     state = 31;
     break;
    case 30: // water_L state
     digitalWrite(valvL,HIGH);
     delay(timeValvL);
     digitalWrite(valvL,LOW);
     trialData = trialData + "32\t" + millis() + "\n";
     state = 32;
     break;
    case 31: // water_R state
     digitalWrite(valvR,HIGH);
     delay(timeValvR);
     digitalWrite(valvR,LOW);
     trialData = trialData + "32\t" + millis() + "\n";
     state = 32;
     break;
    case 27: // error_Rin state
     swError = millis();
     trialData = trialData + "34\t" + millis() + "\n";
     state = 34;
     break;
    case 29: // error_Lin state
     swError = millis();
     trialData = trialData + "34\t" + millis() + "\n";
     state = 34;
     break;
    case 38: // premature_left_poke_in state
     swError = millis();
     trialData = trialData + "34\t" + millis() + "\n";
     state = 34;
     break;
    case 39: // premature_right_poke_in state
     swError = millis();
     trialData = trialData + "34\t" + millis() + "\n";
     state = 34;
     break;
    case 34: // error_tone state
     while((millis()-swError)<300){
       if (random(2) == 1)
         {digitalWrite(spkr,HIGH);}
       else
         {digitalWrite(spkr,LOW);}
     }
     trialData = trialData + "33\t" + millis() + "\n";
     state = 33;
     break;
    case 33: // error_timeout state
     digitalWrite(ledL,HIGH);
     digitalWrite(ledR,HIGH);
     if((millis()-swTrialOn)>timeOut){
       trialData = trialData + "22\t" + millis() + "\n";
       state = 22;
     }
     break;
    case 32: // ITI state
     digitalWrite(ledL,HIGH);
     digitalWrite(ledR,HIGH);
     if((millis()-swTrialOn)>ITI){
       trialData = trialData + "22\t" + millis() + "\n";
       state = 22;
     }
     break;
    case 40: // choice_miss state
     trialData = trialData + "22\t" + millis() + "\n";
     state = 22;
  }
}
