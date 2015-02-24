/* Interval duration discrimination task
 Thiago Gouvea, Learning lab, Nov 2012 */
const int scaling = 9000; // (ms)
const double initSet[] = {0.2, 0.35, 0.42, 0.46, 0.54, 0.58, 0.65, 0.8};
int stimSet[sizeof(initSet)/sizeof(const double)];
//int stimSetInd[] =  {0, 1, 2,2,3,3,3,4,4,4,5,5,6,7};
int stimSetInd[] =  {0, 1, 2,3,4,5,6,7};
//int stimSet[] =  {600, 1050, 1260, 1380, 1450, 1550, 1620, 1740, 1950, 2400};
//int stimSetInd[] =  {0, 1, 2,3,3,3,4,4,5,5,6,6,6,7,8,9};
const int bound = scaling/2;
const int ITI = max(9000,scaling*1.5);;
const int timeOut = max(12000,scaling*3);
const int choiceDeadline = 5000;
const int timeValvL = 150; // Calibrate valves for 3.035 ul with 50
const int timeValvR = 150; // Calibrate valves for 3.027 ul with 50
const int clThre = 3; // Threshold to activate correction loops, exclusive
const int clCredit = 1; // Decrement in error counter for each correct trial (but never goes negative)

// Task parameters
//int stimSet[] = {1050, 1950};
//int stimSet[] =  {1050, 1260, 1740, 1950};
//int stimSet[] =  {1050, 1260, 1380, 1620, 1740, 1950};

//int timeValvL = 115; // Calibrate valves for 25 ul
//int timeValvR = 150; // Calibrate valves for 25 ul

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
int stimCurrent;
int stimIndex;
int error[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
boolean stimLong;
boolean drawStim = true;
String strToPrint = String(state) + '\t' + String(millis());

// PinOut CHECK PIN_OUT FOR VALVES
int syncLed = 2;
int spkr = 3;
int pkC = 8;
int ledC = 9;
int pkL = 5;
int ledL = 6;
int valvL = 7;
int pkR = 11;
int ledR = 12;
int valvR = 4 ;

// Configure start/end of session
//int incomingByte;
void (* resetFunc) (void)=0; // function to restart the protocol

void setup() {
   for (int i=0; i<(sizeof(initSet)/sizeof(double)); i++){
    stimSet[i] = int(initSet[i] * scaling);
  }

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
  strToPrint = String(70) + '\t' + String(millis());
  Serial.println(strToPrint);
  strToPrint = String(106) + '\t' + String(scaling);
  Serial.println(strToPrint);
  state = 22;
  strToPrint = String(state) + '\t' + String(millis());
  Serial.println(strToPrint);
  // strToPrint = String(state) + '\t' + String(millis());;
}

void loop() {

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

  // Run state machine
  switch (state) {

  case 22: // state_0 state
    strToPrint = String(61) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(syncLed,LOW);
    delay(100);
    strToPrint = String(62) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(syncLed,HIGH);
    trialNum++;
    if(drawStim){
      stimIndex = stimSetInd[random(sizeof(stimSetInd)/sizeof(int))];
    } // Argument of random() should be length(stimSet). ToDo: figure out how to implement length() in Arduino's language
    stimCurrent = stimSet[stimIndex];
    stimLong = (stimCurrent > bound);
    strToPrint = String(3) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledC,LOW);
    state = 23;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 23: // wait_Cin state
    if (valuePkC) {
      strToPrint = String(11) + '\t' + String(millis());
      Serial.println(strToPrint);
      digitalWrite(ledC,HIGH);
      swTrialOn = millis();
      state = 56;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    break;

  case 56: // stim_beep1 state
    strToPrint = String(16) + '\t' + String(millis());
    Serial.println(strToPrint);
    tone(spkr,7000,150);
    strToPrint = String(19) + '\t' + String(millis());
    Serial.println(strToPrint);
    state = 57;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 57: // stim_beep2 state
    if((millis()-swTrialOn)>stimCurrent){
      strToPrint = String(17) + '\t' + String(millis());
      Serial.println(strToPrint);
      tone(spkr,7000,150);
      swStimOff = millis();
      strToPrint = String(20) + '\t' + String(millis());
      Serial.println(strToPrint);
      digitalWrite(ledL,LOW);
      strToPrint = String(4) + '\t' + String(millis());
      Serial.println(strToPrint);
      digitalWrite(ledR,LOW);
      strToPrint = String(5) + '\t' + String(millis());
      Serial.println(strToPrint);
      state = 25;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    else if(valuePkL){
      state = 38;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    else if(valuePkR){
      state = 39;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    break;

  case 25: // wait_Sin state
    if((millis()-swStimOff)>choiceDeadline){
      state = 40;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    else{
      if(stimLong){
        if(valuePkL){
          state = 26;
          strToPrint = String(state) + '\t' + String(millis());
          Serial.println(strToPrint);
        }
        else if(valuePkR){
          state = 27;
          strToPrint = String(state) + '\t' + String(millis());
          Serial.println(strToPrint);
        }
      }
      else{
        if(valuePkL){
          state = 29;
          strToPrint = String(state) + '\t' + String(millis());
          Serial.println(strToPrint);
        }
        else if(valuePkR){
          state = 28;
          strToPrint = String(state) + '\t' + String(millis());
          Serial.println(strToPrint);
        }
      }
    }
    break;

  case 26: // correct_Lin state
    error[stimIndex] = error[stimIndex] - clCredit;
    if(error[stimIndex]<0){
      error[stimIndex] = 0;
    }
    if(error[stimIndex]>clThre) { 
      drawStim = false;
    }
    else {
      drawStim = true;
    }
    state = 30;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 28: // correct_Rin state
    error[stimIndex] = error[stimIndex] - clCredit;
    if(error[stimIndex]<0){
      error[stimIndex] = 0;
    }
    if(error[stimIndex]>clThre) { 
      drawStim = false;
    }
    else {
      drawStim = true;
    }
    state = 31;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 30: // water_L state
    digitalWrite(ledL,HIGH);
    strToPrint = String(12) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledR,HIGH);
    strToPrint = String(13) + '\t' + String(millis());
    Serial.println(strToPrint);

    digitalWrite(valvL,HIGH);
    strToPrint = String(6) + '\t' + String(millis());
    Serial.println(strToPrint);
    delay(timeValvL);
    digitalWrite(valvL,LOW);
    strToPrint = String(14) + '\t' + String(millis());
    Serial.println(strToPrint);

    state = 32;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 31: // water_R state
    digitalWrite(ledL,HIGH);
    strToPrint = String(12) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledR,HIGH);
    strToPrint = String(13) + '\t' + String(millis());
    Serial.println(strToPrint);

    digitalWrite(valvR,HIGH);
    strToPrint = String(7) + '\t' + String(millis());
    Serial.println(strToPrint);
    delay(timeValvR);
    digitalWrite(valvR,LOW);
    strToPrint = String(15) + '\t' + String(millis());
    Serial.println(strToPrint);

    state = 32;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 27: // error_Rin state
    swError = millis();
    error[stimIndex]++;
    if(error[stimIndex]>clThre) { 
      drawStim = false;
    }
    else {
      drawStim = true;
    }
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 29: // error_Lin state
    swError = millis();
    error[stimIndex]++;
    if(error[stimIndex]>clThre) { 
      drawStim = false;
    }
    else {
      drawStim = true;
    }
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 38: // premature_left_poke_in state
    swError = millis();
    drawStim = false;
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 39: // premature_right_poke_in state
    swError = millis();
    drawStim = false;
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 34: // error_tone state
    digitalWrite(ledL,HIGH);
    strToPrint = String(12) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledR,HIGH);
    strToPrint = String(13) + '\t' + String(millis());
    Serial.println(strToPrint);
    strToPrint = String(35) + '\t' + String(millis());
    Serial.println(strToPrint);
    while((millis()-swError)<150){
      if (random(2) == 1)
      {
        digitalWrite(spkr,HIGH);
      }
      else
      {
        digitalWrite(spkr,LOW);
      }
    }
    strToPrint = String(36) + '\t' + String(millis());
    Serial.println(strToPrint);
    state = 33;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 33: // error_timeout state
    if((millis()-swError)>timeOut){
      state = 32;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    break;

  case 32: // ITI state
    if((millis()-swTrialOn)>ITI){
      state = 22;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    break;

  case 40: // choice_miss state
    digitalWrite(ledL,HIGH);
    strToPrint = String(12) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledR,HIGH);
    strToPrint = String(13) + '\t' + String(millis());
    Serial.println(strToPrint);
    state = 32;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;
  }
  // ------- End of session script, reset the script in arduino board --------
  if(Serial.read() == 113){
    digitalWrite(13,LOW);
    resetFunc();
  }
}

