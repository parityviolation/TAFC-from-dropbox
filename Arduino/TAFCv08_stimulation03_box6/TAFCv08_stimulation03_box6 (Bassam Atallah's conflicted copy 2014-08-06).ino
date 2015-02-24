/* Interval duration discrimination task
 Thiago Gouvea, Learning lab, Nov 2012 
 BVA & SS Stimulation code Added and Task code modified, April 2013  */
boolean btestlaser =0;
boolean bdebug = 0;

const int scaling = 3000; // (ms)
//const double initSet[] = {0.2, 0.35, 0.42, 0.46, 0.54, 0.58, 0.65, 0.8};
const double initSet[] = {0.15, 0.24, 0.35, 0.42, 0.58, 0.65, 0.76, 0.85};
int stimSet[sizeof(initSet)/sizeof(const double)];
//const int stimSetInd[] =  {0};
//const int stimSetInd[] =  {0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7};
//const int stimSetInd[] =  {0,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,7};
const int stimSetInd[] =  {0,1,2,3,4,5,6,7};
//const int stimSetInd[] =  {0,1,2,3,4,5,6,7};
const int sizeStimSetInd = sizeof(stimSetInd)/sizeof(const int);
const int bound = scaling/2;
const int ITI = 12000;
const int timeOut = 18000;
const int prematuretimeOut =  0 ;
const int choiceDeadline = 5000; 
const int durerrorTone = 150;  // % used for premature too
const int durprematureerrorTone = 0;  // % used for premature too

const int timeValvL = 65;                     // Calibrate valves for 2.58 ul with 50
const int timeValvR = 65;                 // Calibrate valves for 3.66 ul with 50

const boolean bRepeatTrialOnPreMature = 1;    // Set to 1 to make the animal repeat the same stimulus on a PreMature trial
const boolean bEnableCorrectionLoop = 1;      // Set to 1 to ENABLE correction loops 
const int clThre = 3;                         // Threshold to activate correction loops, exclusive
const int clMax =  20;                        // number of correct answers to escape correction loop
const int clCredit = 1;                       // Decrement in error counter for each correct (and incorrect) trial (but never goes negative)


// PinOut CHECK PIN_OUT FOR VALVES
const int syncLed = 2;
const int syncGPIO = 51;
const int spkr = 3;
const int pkC = 8;
const int ledC = 9;
const int pkL = 5;
const int ledL = 6;
const int valvL = 7;
const int pkR = 11;
const int ledR = 12;
const int valvR = 4 ;
const int stimPIN = 22 ; 
const int aoPIN = 45;                        //TIMER 5 (REMEBER TO SET TIMER)

// Cond Parameters (Designed for Cond of Light Stimulation)
 int ninitialTrialsNoStimulation = 10;

 
 int condstimPin[] = {stimPIN,stimPIN,stimPIN};                         // output pin to signal that laser is on
 int condaoPin[] = {aoPIN,aoPIN,aoPIN};                       // output pin supporting PWM
// Stimulation Block properties
 boolean brandomizeBlock = 1 ;                // set to 0 for stimulation in blocks 
 const int condblockSize =10;   
 const int ncond = 1;
 int  binterleaveNoStimBlock = 0;                         // Block of non stimulated blocks between stimualted blocks
 int  sizeInCondBlock[] = {3,1,1};
// Stimulation  properties
// float condamp[] = {25,25,25}; //17 1.5mW //55 7mW// 44 5mW 70 10mW        // percentage of Vcc (usually 5V) NOTE: ramp rate is not changed by condamp
float condamp[] = {80,55,55}; // 30 ADC 10mW
int condpulsefreq[] = {25,10,10};
// int condpulsefreq[] = {5,10,15};    // use 25Hz se -1 if no pulse
 int condpulsewidth[] = {20,20,20}; 
 int onDelay[]  = {0,0,0};
 int conddur_rampUp[] = {1,1,1};     // ms ramp rate: define as the time ramp from 0 to PWM = 255 (not by condamp) 
 int onDuration[]  = {3000,3000,3000};  // time in ms NOTE: Duration time includes dur_rampUp time
 int conddur_rampDn[] = {1,1,1};     // ms ramp rate: define as the time ramp from PWM = 255 to 0  
// EITHER (Triggered Stimulation)
 int onStateTrigger[]  = {56,56,56};                           // This can be any state number, -1 means this trigger will not be used
 int offDelay[]  = {0,0,0};
 int offStateTrigger[]  = {-1,-1,-1};                         // This can be any state number, -1 means this trigger will not be used
// OR (Interval Stimulation)
// NOTE: State must be -1  if using Interval stimulation, However all other cond parameters are valid
//       Interval stimulation also does use condBlock since it is not tied to the trial structure of a task
 boolean bintervalStimulation = 0;
 long stimInterval = 10000 ;       // this is max interval for random interval time in ms (set to -1 if using onStateTrigger)
 long minstimInterval = 1000;      // used for randome interval
 boolean brandstimInterval = 0 ;   // time in ms (set to -1 if using onStateTrigger)


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
const int sizeStimCondBlock = condblockSize*sizeStimSetInd;
int sessioncond[sizeStimCondBlock];
int sessionstim[sizeStimCondBlock];
int indexInSession = -1;                   //current index in sessionXXXX
int sessioncondPM[sizeStimCondBlock];      // array for holding stimuli / cond where animal was premature.. these will be added first when the session repeats
int sessionstimPM[sizeStimCondBlock];      // array for holding stimuli / cond where animal was premature.. these will be added first when the session repeats
int indexInSessionPM = -1;                 //current index in sessionXXXXPM
boolean bsessionPM = 0;                    // is set to 1 when PM stimuli are being represented
int nPM = 0;                               // number PM stimuli saved in sessionXXXXPM
boolean btriggerCondOff = 0;               // set high will start off Delay timer ending Stimulation
boolean btriggerCondOn = 0;                // set high will start on Delay timer before Stimulation
long lastStimulation;                      // for Interval Stimulation
long thisstimInterval;                     // for Interval Stimulation
int indexsuperBlock = 0;
// Internal variables for Task
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
int error[sizeof(initSet)/sizeof(const double)];
boolean stimLong;
boolean breDraw = 1; // Redraw this trial
String strToPrint = String(state) + '\t' + String(millis());

void (* resetFunc) (void)=0;           // function to restart the protocol

void setup() {
 for (int i=0; i<(sizeof(initSet)/sizeof(double)); i++){
    stimSet[i] = int(initSet[i] * scaling);
    error[i] = 0;
  }
  
  pinMode(0,INPUT);
  randomSeed(analogRead(0));
  pinMode(syncLed,OUTPUT);
  pinMode(syncGPIO,OUTPUT);
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
   digitalWrite(syncGPIO,LOW);
  digitalWrite(valvL,LOW);
  digitalWrite(valvR,LOW);
  

  Serial.begin(115200);
  if (!btestlaser){
  while(Serial.read() != 115){
  }
  }
    setupStimulation();
   clearsessionPM();
  createStimCondBlock();

  
  strToPrint = String(70) + '\t' + String(millis());
  Serial.println(strToPrint);
  strToPrint = String(106) + '\t' + String(scaling);
  Serial.println(strToPrint);
  strToPrint = String(85) + '\t' + String(millis()); // begin delivering stimCondBlock
  Serial.println(strToPrint);
  state = 22;
  strToPrint = String(state) + '\t' + String(millis());
  Serial.println(strToPrint);
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
  {currentaoVal = 0;}
  updateao();
  // end of Stimulation
  
  task();

}
void updateao()
{
    if (currentaoVal != lastcurrentaoVal)                                                       // Only write to analogout when there is a change in aoVal
    {
      analogWrite(condaoPin[thisCondIndex], currentaoVal);
      lastcurrentaoVal = currentaoVal;
      if (bdebug)
      {Serial.println(String(888)+ '\t' +  String(indexInSession) + '\t' + String(currentaoVal) + '\t' + String(long(condamp[thisCondIndex]))+ '\t' + String(condaoval));
      }
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
void updateStimCond()
{  
  // BA this code  deals with several cases for stimulus selection
  // 
  if (trialNum == ninitialTrialsNoStimulation) // first block 
  {           strToPrint = String(85) + '\t' + String(millis()); // starting stimcond block again
            Serial.println(strToPrint); 
  }
  if (trialNum < ninitialTrialsNoStimulation) // Optionally start session with trials that are random but not from the Stimulation Stimulus set
  {
    if (breDraw)
    {
      stimIndex = stimSetInd[random(sizeStimSetInd)];
      indexInSession = -1;        // set to 0 instead of -1 because indexInSession is not augmeneted if breDraw
    }
    else {indexInSession = 0;  } // this shouldn't be necessaray but some how indexInSession can be -1 
    
    thisCondIndex = -1;

  }
  else
  {
   //********* Get this trials Stimulus and Stimulation Condition (special cases for PM - PreMature trials)
     if (!bsessionPM )                        // are giving the PM trials for this session yet
    {
      if (breDraw)
        {indexInSession++;}
      if (indexInSession == sizeStimCondBlock){ // switch to using the premature block cause regular block is finished
        bsessionPM=1;
        indexInSessionPM = -1;
        indexInSession = 0;
        strToPrint = String(86) + '\t' + String(millis());
        Serial.println(strToPrint);
      } 
    }
   
   if(bsessionPM)
   {    
     if (breDraw)
     {
       indexInSessionPM++;
       if (indexInSessionPM < nPM)          // PM trials still exist so use one and then get rid of it by setting to -1
       {
            stimIndex = sessionstim[indexInSessionPM]; 
             if (!bintervalStimulation){
              thisCondIndex =  sessioncond[indexInSessionPM]; // NOT USED in interval stimulation indexStimulation used instead
              condThisTrial[thisCondIndex] = 0 ; // not relavent to interval Stimulation
            }
            sessioncondPM[indexInSessionPM] = -1;
            sessionstimPM[indexInSessionPM] = -1;
        }
        else{                                 // PM trials are finished
            bsessionPM =0; 
            indexInSession = 0;
            nPM = 0;
            createStimCondBlock();
            strToPrint = String(85) + '\t' + String(millis()); // starting stimcond block again
            Serial.println(strToPrint); 
        }
      }
         
     }
    
    if (!bsessionPM)
    {
        stimIndex = sessionstim[indexInSession];
        if (!bintervalStimulation) // for interval stimulation 
        {
          thisCondIndex =  sessioncond[indexInSession];     
          condThisTrial[thisCondIndex] = 0 ; // not relavent to interval Stimulation
         }       
    }
    if (!breDraw){
      // No stimulation when in a control loop
      thisCondIndex = -1;
    }
  }
  
   strToPrint = String(120) + '\t' + String(stimIndex); //Stimuulus Indexs of this trial
  Serial.println(strToPrint);
  strToPrint = String(121) + '\t' + String(thisCondIndex); //Condition Indexs of this trial
  Serial.println(strToPrint);


  strToPrint = String(108) + '\t' + String(breDraw); //Redraw on this trial 
  Serial.println(strToPrint);

  //********* 
  if (bdebug)
  {// TROUBLESHOOT    Serial.println(String(indexInSession) + '\t' +  String(stimIndex));// BA
    Serial.println(String(bsessionPM) + '\t' +  String(indexInSession) + '\t' + String(sessionstim[indexInSession])  + '\t' + String(stimSet[stimIndex]) + '\t' + String(sessioncond[indexInSession]) + '\t' + String(long(condamp[thisCondIndex])) + '\t' +  String(onStateTrigger[thisCondIndex]));
  }
  
 }
void task()
{
 
  // Run state machine
  switch (state) {

  case 22: // state_0 state
  // THis is a hack it is not clear why this timer needs to be reset each time
   TCCR5B = (TCCR5B & 0xF8) | 0x01;                         // set Timer to 32kHz //http://sobisource.com/?p=195 

    updateStimCond();
    
    strToPrint = String(61) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(syncLed,LOW);
    digitalWrite(syncGPIO,HIGH); 
    delay(100);
    strToPrint = String(62) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(syncLed,HIGH);
    digitalWrite(syncGPIO,LOW);
    
    trialNum++; 

    stimCurrent = stimSet[stimIndex];
    stimLong = (stimCurrent > bound);
    strToPrint = String(3) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledC,LOW);
    
    if (stimCurrent < stimSet[0])  // If an error occurs catch it and reset the updateStimCond
    {
         Serial.println(String(-1) + '\t' + String(stimCurrent)+ '\t' +  String(bsessionPM) + '\t' + String(indexInSessionPM) + '\t' +  String(indexInSession) + '\t' + String(sessionstim[indexInSession])  + '\t' + String(stimSet[stimIndex]) + '\t' + String(sessioncond[indexInSession]) + '\t' + String(long(condamp[thisCondIndex])) + '\t' +  String(onStateTrigger[thisCondIndex]));
         indexInSession = 0;
          updateStimCond();
    }
       
    if (stimCurrent > stimSet[sizeof(stimSet)/sizeof(int)-1])  // If an error occurs catch it and reset the updateStimCond
    {
        Serial.println(String(-2) + '\t' + String(stimCurrent)+ '\t' +  String(bsessionPM) + '\t' + String(indexInSessionPM) + '\t' +  String(indexInSession) + '\t' + String(sessionstim[indexInSession])  + '\t' + String(stimSet[stimIndex]) + '\t' + String(sessioncond[indexInSession]) + '\t' + String(long(condamp[thisCondIndex])) + '\t' +  String(onStateTrigger[thisCondIndex]));
       indexInSession = 0;
       updateStimCond();
    }
    state = 23;
   
    
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 23: // wait_Cin state
    
    if (bdebug)
    {// TROUBLESHOOT
    //    while(Serial.read() != 115){
    //  }
      valuePkC = 1; 
    }
    
    
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
  
    if (bdebug)
    {// TROUBLESHOOT
    //    while(Serial.read() != 115){
    //  }
      valuePkL = 1; 
    }
    
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
    correctionLoopHelper(-clCredit);
    state = 30;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 28: // correct_Rin state
    correctionLoopHelper(-clCredit);
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
    correctionLoopHelper(clCredit);
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 29: // error_Lin state
    swError = millis();
    correctionLoopHelper(clCredit);
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 38: // premature_left_poke_in state
    swError = millis();
    state = 209;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);

    if  (trialNum > ninitialTrialsNoStimulation & breDraw)
    {
    // Save cond and stim in premature 
        sessioncondPM[nPM] = thisCondIndex ;
        sessionstimPM[nPM] = stimIndex;
        nPM++;
        if (nPM == sizeStimCondBlock){
          nPM = 0;
        }
  
    }
    
    if(bRepeatTrialOnPreMature)
    {
        breDraw =0;
    }    
     break;
  
    case 39: // premature_right_poke_in state
        swError = millis();
       state = 209;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);

    if  (trialNum > ninitialTrialsNoStimulation & breDraw)
    {
    // Save cond and stim in premature 
        sessioncondPM[nPM] = thisCondIndex ;
        sessionstimPM[nPM] = stimIndex;
        nPM++;
        if (nPM == sizeStimCondBlock){
          nPM = 0;
        }
    }
    
    if(bRepeatTrialOnPreMature)
    {
        breDraw =0;
    }
    break;

  case 209: // Premature Tone State
    errorTone(durprematureerrorTone);
    state = 210;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 210: // error_timeout state
    if((millis()-swError)>prematuretimeOut){
      state = 32;
      strToPrint = String(state) + '\t' + String(millis());
      Serial.println(strToPrint);
    }
    break;

  case 34: // error_tone state
    errorTone(durerrorTone);
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
}

void correctionLoopHelper(int credit)
{
  if (bEnableCorrectionLoop)
  {
     error[stimIndex] = error[stimIndex] + credit;
     if(error[stimIndex]<0){
        error[stimIndex] = 0;
     } 
     else if(error[stimIndex]>(clThre + clMax))
     {
       error[stimIndex] = clThre + clMax;
     }
     if(error[stimIndex]>clThre) { 
       breDraw = 0;
       strToPrint = String(109) + '\t' + String(error[stimIndex]); 
       Serial.println(strToPrint);
     }
     else {
       breDraw = 1;
     }
  }
  else{
   breDraw = 1;
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
     {Serial.println(String(111) + '\t' +   String(condRAMPSTEPUp[i]) + '\t' + String(condstepintv_Up[i]) + '\t' + String(condRAMPSTEPDn[i]) + '\t' + String(condstepintv_Dn[i]));
     }
   }
   delay(500); // FLASH Stim PINs for half a sec
   for (  int i  = 0; i < ncond ; i++){ 
   digitalWrite(condstimPin[i],LOW);
   analogWrite(condaoPin[i], 0);
   }
   
   if (btestlaser){
     binterleaveNoStimBlock = 0;
     
      ninitialTrialsNoStimulation = 0;
       sizeInCondBlock[0] = condblockSize;
// Stimulation  properties
     // condpulsefreq[0] = -1 ;   
     // onDuration[0]  = 4000; 
      Serial.println(String(-1000) + '\t' + String(-100000000));// TROUBLESHOOT
      }
    
    indexsuperBlock = random(1,3);  // Randomally pick whether  session starts with or without stimulation

}

void clearsessionPM()
{
  for (int i = 0; i < sizeStimCondBlock; i++){
    sessioncondPM[i] = -1;
    sessionstimPM[i] = -1;
  }
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
  
  
  int stimBlock[sizeStimSetInd];
  for ( j  = 0; j < sizeStimSetInd; j++){
    stimBlock[j] = stimSetInd[j];
  }
    
   if (bdebug)
   {//BA TROUBLESHOOT
        for ( j  = 0; j < condblockSize; j++){
          Serial.println(String( condBlock[j])); // trial stimulus
         }
    }
  if(brandomizeBlock){
    //
    for ( i  = 0; i < condblockSize ; i++){
      for ( j  = 0; j < sizeStimSetInd; j++){
        sessionstim[i*sizeStimSetInd+j] = stimBlock[j]; // trial stimulus
        sessioncond[i*sizeStimSetInd+j] = condBlock[i];  //trial condition
      }
    }
    bubbleUnsort2d((int*) sessionstim, (int*) sessioncond, sizeStimCondBlock);
  }
  else // stimulate in  NOTE: Stimuli and Stimulation Conditions are not matched in block stimulation
  {
    //
    for ( i  = 0; i < condblockSize ; i++){
       bubbleUnsort((int*) stimBlock, sizeStimSetInd) ;
      for ( j  = 0; j < sizeStimSetInd; j++){
        sessionstim[i*sizeStimSetInd+j] = stimBlock[j]; // trial stimulus
        sessioncond[i*sizeStimSetInd+j] = condBlock[i];
      }
    }
     
  }
     if (bdebug)
   {//BA TROUBLESHOOT
        for ( j  = 0; j < sizeStimCondBlock; j++){
          Serial.println(String(-1) + '\t'+ String(sessionstim[j]) + '\t'+ String(sessioncond[j]) + '\t'+ String(stimSet[sessionstim[j]]) ); // trial stimulus
         }
       Serial.println(String(sizeStimCondBlock));
   }
   indexsuperBlock = indexsuperBlock+1;

}

void bubbleUnsort2d(int *list, int *list2, int elem) //Fisher Yates Shuffle http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
{
  for (int a=elem-1; a>0; a--)
  {
    int r = random(a+1);
    //int r = rand_range(a+1);
    if (r != a)
    {
      //      Serial.println(String(a) + '\t' +  String(list[a][1]) + '\t' + String(list[a][2]) + '\t' +  String(list[r][1]) + '\t' +   String(list[r][2]));

      int temp = list[a];
      list[a] = list[r];     
      list[r] = temp;


      temp = list2[a];
      list2[a] = list2[r];     
      list2[r] = temp;

    }
  }
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
        { thisstimInterval = minstimInterval + random(onDuration[thisCondIndex]+10,stimInterval-minstimInterval);}
       
         indexStimulation ++;
         if (indexStimulation == (sizeStimCondBlock-1))
         {indexStimulation = 0;}
    } 
  }        
}
void stimulationTriggerHelper()
{
  // handle case where State Triggers Stimulation ON/OFF
  if (thisCondIndex!= -1)
  {
    if(condPIN_Status[thisCondIndex] == 0 && state == onStateTrigger[thisCondIndex])
    {
       btriggerCondOn = 1;
     }
    else if(condPIN_Status[thisCondIndex] == 1 && state == offStateTrigger[thisCondIndex])
    {
       btriggerCondOff = 1;
    }
    
    // actually start the counter
    if ( btriggerCondOn)
    {  timeonDelay = millis();
       btriggerCondOn =0;
       condThisTrial[thisCondIndex] = 1;
    }
    else if ( btriggerCondOff)
    {  timeoffDelay = millis();
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
      {  Serial.println(String(99) + '\t' + String(condaoval));// TROUBLESHOOT
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
        {  currentaoVal = condaoval;
            lastPulseHigh[thisCondIndex] = millis();  
        }
        if (currentaoVal!=0 && (millis()-lastPulseHigh[thisCondIndex]) >= condpulsewidth[thisCondIndex])
        { currentaoVal = 0;
        }
     
      }
      else{ currentaoVal = condaoval;
    }
      if (bdebug) 
      {         Serial.println(String(999) + '\t' + String(currentaoVal) + '\t' +  String(condpulsewidth[thisCondIndex])+ '\t' +  String(condpulseinterval[thisCondIndex]));
      }
    }
  }
}

void errorTone(int durTone)
{
    unsigned long now = millis();
    digitalWrite(ledL,HIGH);
    strToPrint = String(12) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(ledR,HIGH);
    strToPrint = String(13) + '\t' + String(millis());
    Serial.println(strToPrint);
    strToPrint = String(35) + '\t' + String(millis());
    Serial.println(strToPrint);
     while((millis()-now)<durTone){
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
}




