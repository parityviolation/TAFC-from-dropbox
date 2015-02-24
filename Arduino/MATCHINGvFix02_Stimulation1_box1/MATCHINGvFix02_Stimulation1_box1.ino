/* MATCHINGvFix01
 Matching Task, with fixation
 NO LASER
 Learning lab, Feb 2013 */
// BA added out put of required waiting time code 106
boolean btestlaser = 0;
boolean bdebug =0;
int selectStart=-1; // set  to 1 to start on left block 0 for right 
// -1 for random

// Task parameters
int a = 1;
int pHi =  90; // 0-100% Higher reward probability
int pLo =  10; // 0-100% Lower reward probability
int blockLenMin = 50;
int blockLenMax = 50; // this + blockLenMin
int ITI = 9000; // (ms)
int choiceDeadline = 60000; // (ms)
int timeOut = 6000; // (ms)
int rwdDelay = 0; // (ms)
int timeValvL = 100; //70 4uL// 60 Calibrate valves for 2.0ul
int timeValvR = 100; //70 4uL// 60 Calibrate valves for 2.0 ul
int waitTarget = 3000;// Time (ms) the animal is required to wait at the center poke
int waitMin = 1600;
int wait = waitMin;
int waitIncr = 20;
int waitDecr = 2;
//int laserOnset = 300; // Relative to reward onset
//int laserDurS = 300;  // Short laser stimulation
//int laserDurL = 450; // Long laser stimulation
//int earlyBlock = 20; // Number of trials since block transition until performance stabilizes

int toneFreq = 3000;
int toneDur = 150;


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
const int stimPIN = 22 ; 
const int aoPIN = 44;  

// Cond Parameters (Designed for Cond of Light Stimulation)
int ninitialTrialsNoStimulation =2;


int condstimPin[] = {
  22,22,22};                         // output pin to signal that laser is on
int condaoPin[] = {
  aoPIN,aoPIN,aoPIN};                       // output pin supporting PWM
// Stimulation Block properties
boolean brandomizeBlock = 0 ;                // set to 0 for stimulation in blocks 
const int condblockSize =3; 
int sizeStimCondBlock =  condblockSize;
const int ncond = 1;
int  stimulationSelector = 3;   // 1 - blocks only, 2 - interval (not blocks) 3 - probability (and blocks)
int condProbOfStimulation[] = {
  30,30,30} 
;   // number between 0 and 100} NOTE for blocks only all number will be set to 100 automatically
int  sizeInCondBlock[] = {
  1,1,1};
// Stimulation  properties
float condamp[] = {
  45,45,45};   //53 for a867     //17 for 1013  // (30 for SERT) 39 10mW  20for 5mW 17 for 1.5mW percentage of Vcc (usually 5V) NOTE: ramp rate is not changed by condamp
//int condpulsefreq[] = {40,25,12};     //45 5.5mW // use 25Hz se -1 if no pulse
int condpulsefreq[] = {
  25,12,6};     //45 5.5mW // use 25Hz se -1 if no pulse
int condpulsewidth[] = {
  20,20,20}; 
int onDelay[]  = {
  0,0,0};
int conddur_rampUp[] = {
  1,1,1};     // ms ramp rate: define as the time ramp from 0 to PWM = 255 (not by condamp) 
int onDuration[]  = {
  1000,1000,1000};  // time in ms NOTE: Duration time includes dur_rampUp time
int conddur_rampDn[] = {
  1,1,1};     // ms ramp rate: define as the time ramp from PWM = 255 to 0  
// EITHER (Triggered Stimulation)
int onStateTrigger[]  = {
  100,100,100};                           // This can be any state number, -1 means this trigger will not be used
int onStateTrigger1[]  = {
  100,100,100};                           // This SECOND state number, -1 means this trigger will not be used
int offDelay[]  = {
  0,0,0};
int offStateTrigger[]  = {
  -1,-1,-1};                         // This can be any state number, -1 means this trigger will not be used
// OR (Interval Stimulation)
// NOTE: State must be -1  if using Interval stimulation, However all other cond parameters are valid
//       Interval stimulation also does use condBlock since it is not tied to the trial structure of a task
boolean bintervalStimulation = 0;  // stimulationSelector 2
long stimInterval = 10000 ;       // this is max interval for random interval time in ms (set to -1 if using onStateTrigger)
long minstimInterval = 1000;      // used for randome interval
boolean brandstimInterval = 0 ;   // time in ms (set to -1 if using onStateTrigger)

int  binterleaveNoStimBlock = 0;                         // Block of non stimulated blocks between stimualted blocks
long indexStimulation = 0;             // for internal house keeping 
int condRAMPSTEPUp[ncond];             // for internal house keeping              
int condRAMPSTEPDn[ncond];             // for internal house keeping  
int condthisrampstep[ncond];           // for internal house keeping
long condthisstepintv[ncond];          // for internal house keeping
long condstepintv_Up[ncond] ;          // for internal house keeping
long condstepintv_Dn[ncond] ;          // for internal house keeping
long condaoval = 0;                    // for internal house keeping
long condlastStepAt[ncond];            // ms time of last step

long  condpulseinterval[ncond];        //  Pulse for internal house keeping
long lastPulseHigh[ncond];             // Pulse for internal house keeping
long currentaoVal = 0;                 // Pulse for internal house keeping 
long lastcurrentaoVal = -1;            // updateao for internal house keeping 

// More Internal Cond Variables
int condBlock[condblockSize];
boolean condPIN_Status[ncond];         // is high when the PIN is high
boolean condThisTrial[ncond];          // is high if stimulation has occured this trial
long timeonDelay = -1;
long timeoffDelay = -1;
long timeonDuration = -1;
int thisCondIndex = 0;
int sessioncond[condblockSize];
int indexInSession = -1;                   //current index in sessionXXXX
boolean btriggerCondOff = 0;               // set high will start off Delay timer ending Stimulation
boolean btriggerCondOn = 0;                // set high will start on Delay timer before Stimulation
long lastStimulation;                      // for Interval Stimulation
long thisstimInterval;                     // for Interval Stimulation
int indexsuperBlock = 0;

// Internal variables
int coinL;
int coinR;
int state;
int trialNum = 0;
int blockCount = 0;
int trialCount = 0;
int blockLenCurrent = 0;
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
String strToPrint = String(state) + '\t' + String(millis());


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
  setupStimulation();

  createStimCondBlock();

  Serial.println(String(70) + '\t' + String(millis()));
  state = 22;
  Serial.println(String(state) + '\t' + String(millis()));


  switch(selectStart)
  {
  case 1: // STart LEFt
    leftHi = true;
  case 0:
    leftHi = false;

  case -1:
    if (random(2)==1)
    {
      leftHi = false;
    }
    else
    {
      leftHi = true;
    }
  }

  blockLenCurrent = blockLenMin + random(blockLenMax+1);
}
void loop() {

  updatePokes();

  // Stimulation
  intervalStimulationCounter();
  stimulationTriggerHelper();
  stimulationOnOff();
  rampPWM();
  pulsePWM();
  if (thisCondIndex == -1)// default Cond is on stimulation
  {
    currentaoVal = 0;
  }
  updateao();
  // end of Stimulation
  task();
}

void createStimCondBlock()
{ // this creates the stimuli and conditions that for each trial and 
  // containing the number of instances of each consition in the block that are specified in sizeInBlock
  // first condBlock is created
  // e.g. condblockSize = 10 and sizeInCondBlock = {3,2,-1};  then 
  //               condBlock = {0,0,0,1,1,-1,-1,-1,-1,-1};
  // -1 means default condition i.e. condPIN will not e changed during this trial
  // then condBlock is repeated for each stimulus
  int index = 0;
  int i;
  int j;
  // Create condition block 
  for ( i  = 0; i < condblockSize ; i++){
    condBlock[i] = -1;  // by default the entire block is no stimulation
  }

  int N = 1;
  if (binterleaveNoStimBlock)
  {
    N = 2;
  }

  if (!(indexsuperBlock % N))
  {
    for ( i  = 0; i < ncond ; i++){ // fill condition block with parts of the block
      for ( j  = 0; j < sizeInCondBlock[i] ; j++){
        condBlock[index] = i; 
        index++;
      }
    }
  }  

  if (bdebug)
  {//BA TROUBLESHOOT
    for ( j  = 0; j < condblockSize; j++){
      Serial.println(String( condBlock[j])); // trial stimulus
    }
  }
  if(brandomizeBlock)
  {
    bubbleUnsort((int*) condBlock, condblockSize) ;   
  }

  if (bdebug)
  {//BA TROUBLESHOOT
    for ( j  = 0; j < condblockSize; j++){
      Serial.println(String( condBlock[j])); // trial stimulus
    }
  }
  indexsuperBlock = indexsuperBlock+1;

}

void bubbleUnsort(int *list, int elem) // There should be a way to fold this into the bubbleUnsort2d
{
  for (int a=elem-1; a>0; a--)
  {
    int r = random(a+1);
    //int r = rand_range(a+1);
    if (r != a)
    {
      int temp = list[a];
      list[a] = list[r];   
      list[r] = temp;
    }
  }
}// from here http://arduino.cc/forum/index.php?topic=43424.0



void task(){
  // Run state machine
  switch (state) {
  case 22: // state_0 state
    // THis is a hack it is not clear why this timer needs to be reset each time
    TCCR5B = (TCCR5B & 0xF8) | 0x01;                         // set Timer to 32kHz //http://sobisource.com/?p=195 
    updateStimCond();

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

    Serial.println(String(107) + '\t' + String(wait));
    if (bdebug)
    {//BA TROUBLESHOOT
      if (leftHi){
        Serial.println(String(1000) + '\t' + String(1));
      }
      else{
        Serial.println(String(1000) + '\t' + String(0));
      }
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
      tone(spkr,toneFreq,toneDur);
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
      tone(spkr,toneFreq,toneDur);
      delay(100);
      tone(spkr,toneFreq,toneDur);

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
      {
        digitalWrite(spkr,HIGH);
      }
      else
      {
        digitalWrite(spkr,LOW);
      }
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

/*==============================================================================
 * SETUP FUNCTIONS()
 *============================================================================*/

void setupStimulation()
{
  //Setup AO and condition varuables
  TCCR5B = (TCCR5B & 0xF8) | 0x01;                               // set Timer to 32kHz //http://sobisource.com/?p=195 
  for (  int i  = 0; i < ncond ; i++){ 
    pinMode(condaoPin[i], OUTPUT);                               // sets the pin as output
    analogWrite(condaoPin[i], 255);
    pinMode(condstimPin[i], OUTPUT);                             // sets the pin as output
    digitalWrite(condstimPin[i],HIGH);
    condPIN_Status[i] = 0;
    condThisTrial[i] = 0;
    lastPulseHigh[i] = 0; 
    condthisrampstep[i] = 0;
    condRAMPSTEPUp[i] = max(1,min(255/conddur_rampUp[i],255));
    condRAMPSTEPDn[i] = -1*max(1,min(255/conddur_rampDn[i],255));
    condstepintv_Up[i] = conddur_rampUp[i]/(255/condRAMPSTEPUp[i]); 
    condstepintv_Dn[i] = conddur_rampDn[i]/(255/abs(condRAMPSTEPDn[i])); 
    condthisstepintv[i] = 0;    
    condpulseinterval[i] = 1000/condpulsefreq[i]; 
    if (bdebug)
    {
      Serial.println(String(111) + '\t' +   String(condRAMPSTEPUp[i]) + '\t' + String(condstepintv_Up[i]) + '\t' + String(condRAMPSTEPDn[i]) + '\t' + String(condstepintv_Dn[i]));
    }
  }
  delay(2000); // FLASH Stim PINs for half a sec
  for (  int i  = 0; i < ncond ; i++){ 
    digitalWrite(condstimPin[i],LOW);
    analogWrite(condaoPin[i], 0);
  }

  if (btestlaser){
    stimulationSelector = -1;
  }

  switch (stimulationSelector)
  {
  case 1:
    bintervalStimulation = 0;
    for (  int i  = 0; i < ncond ; i++){ 
      condProbOfStimulation[i] = 100;
    }
  case 2:
    for (  int i  = 0; i < ncond ; i++){ 
      condProbOfStimulation[i] = 100;
    }
    bintervalStimulation = 1;
  case 3:
    bintervalStimulation = 0;

  case -1:  // btestlaser
    for (  int i  = 0; i < ncond ; i++){ 
      condProbOfStimulation[i] = 100;
    }
    binterleaveNoStimBlock = 0;

    ninitialTrialsNoStimulation = 0;
    sizeInCondBlock[0] = condblockSize;
    // Stimulation  properties
    onStateTrigger[0] = 23;
    condpulsefreq[0] = -1 ;   
    onDuration[0]  = 3000; 
    Serial.println(String(-1000) + '\t' + String(-100000000));// TROUBLESHOOT
  }

  indexsuperBlock = random(1,2);  // Randomally pick whether  session starts with or without stimulation


}

void updateao()
{
  if (currentaoVal != lastcurrentaoVal)                                                       // Only write to analogout when there is a change in aoVal
  {
    analogWrite(condaoPin[thisCondIndex], currentaoVal);
    lastcurrentaoVal = currentaoVal;
    if (bdebug)
    {
      Serial.println(String(888)+ '\t' +  String(indexInSession) + '\t' + String(currentaoVal) + '\t' + String(long(condamp[thisCondIndex]))+ '\t' + String(condaoval));
    }
  }
}

void updateStimCond()
{  
  // BA this code is annoyingly complicated because it deals with several cases for smtimulus selection
  // 
  if (trialNum < ninitialTrialsNoStimulation) // Optionally start session with trials that are random but not from the Stimulation Stimulus set
  {   
    indexInSession = 0; // this shouldn't be necessaray but some how indexInSession can be -1 
    thisCondIndex = -1;

  }
  else
  {
    //********* Get this trials Stimulus and Stimulation Condition (special cases for PM - PreMature trials)

    indexInSession++;
    if (indexInSession == condblockSize){ // switch to using the premature block cause regular block is finished
      indexInSession = 0;
      strToPrint = String(86) + '\t' + String(millis());
      Serial.println(strToPrint);
      createStimCondBlock();
      strToPrint = String(85) + '\t' + String(millis()); // starting stimcond block again

    } 
    thisCondIndex = condBlock[indexInSession];
  } 
}

/*==============================================================================
 * STIMULATION FUNCTIONS()
 *============================================================================*/
void intervalStimulationCounter()
{      
  if (bintervalStimulation)// check if this condition isi pulsed
  {  
    thisCondIndex =  sessioncond[indexStimulation]; 
    if ((millis()-lastStimulation) >= thisstimInterval)
    {     
      btriggerCondOn =1; // Trigger Stimulation (for Stimulation Helper to take care of)     
      lastStimulation = millis();

      if (brandstimInterval) // NOTE: interval  can't be short than the Duration of stimulation
      { 
        thisstimInterval = minstimInterval + random(onDuration[thisCondIndex]+10,stimInterval-minstimInterval);
      }

      indexStimulation ++;
      if (indexStimulation == (sizeStimCondBlock-1))
      {
        indexStimulation = 0;
      }
    } 
  }        
}
void stimulationTriggerHelper()
{
  // handle case where State Triggers Stimulation ON/OFF
  if (thisCondIndex!= -1)
  {
    if(condPIN_Status[thisCondIndex] == 0 && (state == onStateTrigger[thisCondIndex]||state == onStateTrigger1[thisCondIndex]) )
    { 
      if (bdebug)
      {
        strToPrint = String(-2000) + '\t' + String(condProbOfStimulation[thisCondIndex]);
        Serial.println(strToPrint);
      }

      if (random(0,99) < condProbOfStimulation[thisCondIndex])
      {
        btriggerCondOn = 1;
      }
    }
    else if(condPIN_Status[thisCondIndex] == 1 && state == offStateTrigger[thisCondIndex])
    {
      btriggerCondOff = 1;
    }

    // actually start the counter
    if ( btriggerCondOn)
    {  
      timeonDelay = millis();
      btriggerCondOn =0;
      condThisTrial[thisCondIndex] = 1;
    }
    else if ( btriggerCondOff)
    {  
      timeoffDelay = millis();
      btriggerCondOff =0;
    }
  }
}

void stimulationOnOff()
{
  if (thisCondIndex!= -1)
  {// Turn on Stimulation Pin
    if( timeonDelay != -1 && onDelay[thisCondIndex] != -1 && (millis() - timeonDelay ) > onDelay[thisCondIndex]){
      digitalWrite(condstimPin[thisCondIndex],HIGH);
      condPIN_Status[thisCondIndex] = 1;
      condthisrampstep[thisCondIndex] = condRAMPSTEPUp[thisCondIndex];
      condthisstepintv[thisCondIndex] = condstepintv_Up[thisCondIndex];
      timeonDuration = millis();
      strToPrint = String(1000+thisCondIndex) + '\t' + String(millis());
      Serial.println(strToPrint);
      timeonDelay = -1;
    } 
    // Turn off Stimulation Pin because duration is reached
    else if( timeonDuration != -1 && (millis() - timeonDuration ) > onDuration[thisCondIndex]){
      digitalWrite(condstimPin[thisCondIndex],LOW);
      condPIN_Status[thisCondIndex] = 0;
      condthisrampstep[thisCondIndex] = condRAMPSTEPDn[thisCondIndex] ;
      condthisstepintv[thisCondIndex] = condstepintv_Dn[thisCondIndex];
      strToPrint = String(1050+thisCondIndex) + '\t' + String(millis());
      Serial.println(strToPrint);
      timeonDuration = -1;
    }
    // Turn off Stimulation Pin because Delay off is reached NOT TESTED
    else if( timeoffDelay != -1 && (millis() - timeoffDelay ) > offDelay[thisCondIndex]){
      digitalWrite(condstimPin[thisCondIndex],LOW);
      condPIN_Status[thisCondIndex] = 0;
      condthisrampstep[thisCondIndex] = condRAMPSTEPDn[thisCondIndex];
      condthisstepintv[thisCondIndex] = condstepintv_Dn[thisCondIndex];
      strToPrint = String(1050+thisCondIndex)  + '\t' + String(millis());
      Serial.println(strToPrint);
      timeoffDelay = -1;
      timeonDuration = -1;
    }
  }
}

void rampPWM()
{ 
  if  (thisCondIndex !=-1) // ramp is undefined for default condition
  {
    if ( condthisrampstep[thisCondIndex] != 0){
      // ramp up
      if (millis()>(condlastStepAt[thisCondIndex]+condstepintv_Up[thisCondIndex])){
        condlastStepAt[thisCondIndex] = millis();
        condaoval = condaoval+condthisrampstep[thisCondIndex];
      }
      // check if zero/ amplitude has been reached.
      if( condaoval >=(int(255*(condamp[thisCondIndex]/100)))){
        condaoval = (int(255*(condamp[thisCondIndex]/100)));
        condthisrampstep[thisCondIndex] = 0;
      }
      if( condaoval <= 0) {
        condaoval = 0 ;
        condthisrampstep[thisCondIndex] = 0;
      }
      if (bdebug) 
      {  
        Serial.println(String(99) + '\t' + String(condaoval));// TROUBLESHOOT
      }
    }
  }

}

void pulsePWM()
{
  if  (thisCondIndex !=-1) // pulse is undefined for default condition
  {
    if (!(condaoval == 0 & currentaoVal == 0))
    {
      if (condpulsefreq[thisCondIndex]!=-1 ) // check if this condition isi pulsed
      {  
        if ((millis()-lastPulseHigh[thisCondIndex]) >= condpulseinterval[thisCondIndex])
        {  
          currentaoVal = condaoval;
          lastPulseHigh[thisCondIndex] = millis();  
        }
        if (currentaoVal!=0 && (millis()-lastPulseHigh[thisCondIndex]) >= condpulsewidth[thisCondIndex])
        { 
          currentaoVal = 0;
        }

      }
      else{ 
        currentaoVal = condaoval;
      }
      if (bdebug) 
      {         
        Serial.println(String(999) + '\t' + String(currentaoVal) + '\t' +  String(condpulsewidth[thisCondIndex])+ '\t' +  String(condpulseinterval[thisCondIndex]));
      }
    }
  }
}




