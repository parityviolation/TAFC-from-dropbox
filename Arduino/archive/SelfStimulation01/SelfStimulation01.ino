/* Self Stimulation
 BVA & SS May 2013  */
 **************** NOT WORKING

int stimSetInd[4]; // this variable is not used in the Task but exists so that 
const int sizeStimSetInd = sizeof(stimSetInd)/sizeof(const int);
const int ITI = 9000;
const boolean bwaterreward = 0; // This disables water reward


const int timeValvL = 70;                     // Calibrate valves for 2.58 ul with 50
const int timeValvR = 70;                    // Calibrate valves for 3.66 ul with 50

// PinOut CHECK PIN_OUT FOR VALVES
const int syncLed = 2;
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
const int aoPIN = 44;

// Cond Parameters (Designed for Cond of Light Stimulation)
const int condblockSize = 2;
const int ncond = 1;
boolean brandomizeBlock = 0 ;        // set to 0 for stimulation in blocks 
const int  sizeInCondBlock[] = {
  2,0,0};
const float condamp[] = {
  99,0,0};                         // percentage of Vcc (usually 5V) NOTE: this doesn't change ramp rate
const int onDelay[]  = {
  0,0,0};
const int onDuration[]  = {
  500,0,0};                          // time in ms
// NOTE: State must be -1 if using Interval stimulation, However all other cond parameters are valid
//       Interval stimulation also does use condBlock since it is not tied to the trial structure of a task
//EITHER
const boolean bintervalStimulation = 0;
const unsigned long stimInterval = 10000 ; // this is max interval for random interval time in ms (set to -1 if using onStateTrigger)
const unsigned long minstimInterval = 1000; // used for randome interval
const boolean brandstimInterval = 0 ; // time in ms (set to -1 if using onStateTrigger)
unsigned long indexStimulation = 0;
// OR
const int onStateTrigger[]  = {
  31,-1,-1};                             // This can be any state number, -1 means this trigger will not be used
const int offDelay[]  = {
  0,0,0};
const int offStateTrigger[]  = {
  -1,-1,-1};                         // This can be any state number, -1 means this trigger will not be used
// Analogout setup
const int condstimPin[] = {
  22,23,stimPIN};                       // output pin to signal that laser is on
const int condaoPin[] = {
  aoPIN,aoPIN,aoPIN};                       // output pin supporting PWM
const unsigned long conddur_rampUp[] = {     // NOTE: rampUp is also used for ramping down
 1,1,1};    
 // ms ramp rate: define as the time ramp from 0 to condamp.  
 // step (i.e. no ramp) set  conddur_rampUp =1  and condRAMPSTEP = 255
const int condRAMPSTEP[] = {
  255,255,255};                       // step size of change in PWM duty cycle, NOTE: if dur_rampUp is faster than 255 then step size should be increased so that stepintv_Up > 0
int condthisrampstep[] = {
  0,0,0};                             // for internal house keeping
long condstepintv_Up[ncond] ;          // for internal house keeping
long condaoval = 0;                // for internal house keeping
long condlastStepAt[ncond];  // ms time of last step
// Pulses?
const  int condpulsefreq[] = {50,-1,-1}; // use -1 if no pulse
const unsigned int condpulsewidth[] = {5,0,0}; 
long  condpulseinterval[ncond]; // for internal house keeping
long lastPulseHigh[ncond];    // for internal house keeping
long currentaoVal = 0;    // for internal house keeping 
long lastcurrentaoVal = -1;    // for internal house keeping 

// More Internal Cond Variables
int condBlock[condblockSize];
boolean condPIN_Status[ncond];           // is high when the PIN is high
boolean condThisTrial[ncond];              // is high if stimulation has occured this trial
long timeonDelay = -1;
long timeoffDelay = -1;
long timeonDuration = -1;
int thisCondIndex = 0;
const int sizeStimCondBlock = condblockSize*sizeStimSetInd;
int sessioncond[sizeStimCondBlock];
int sessionstim[sizeStimCondBlock];
int indexInSession = -1;                   //current index in sessionXXXX
int sessioncondPM[sizeStimCondBlock]; // array for holding stimuli / cond where animal was premature.. these will be added first when the session repeats
int sessionstimPM[sizeStimCondBlock]; // array for holding stimuli / cond where animal was premature.. these will be added first when the session repeats
int indexInSessionPM = -1;                 //current index in sessionXXXXPM
boolean bsessionPM = 0;               // is set to 1 when PM stimuli are being represented
int nPM = 0;                          // number PM stimuli saved in sessionXXXXPM
boolean btriggerCondOff = 0;          // set high will start off Delay timer ending Stimulation
boolean btriggerCondOn = 0;           // set high will start on Delay timer before Stimulation
unsigned long lastStimulation;         // for Interval Stimulation
unsigned long thisstimInterval;        // for Interval Stimulation

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
boolean stimLong;
String strToPrint = String(state) + '\t' + String(millis());

boolean bdebug = 1; //Debugging mode

// Configure start/end of session
//int incomingByte;
void (* resetFunc) (void)=0;           // function to restart the protocol

void setup() {

  
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
  clearsessionPM();
  createStimCondBlock();

  
  strToPrint = String(70) + '\t' + String(millis());
  Serial.println(strToPrint);
  state = 22;
  strToPrint = String(state) + '\t' + String(millis());
  Serial.println(strToPrint);
}



void loop() {


  updatePokes();
  
  intervalStimulationCounter();
  stimulationTriggerHelper();
  stimulationOnOff();
  rampPWM();
  pulsePWM();
  if (thisCondIndex == -1)// default Cond is on stimulation
  {currentaoVal = 0;}
  updateao();
  
  task();

}
void updateao()
{
    if (currentaoVal != lastcurrentaoVal)                                                       // Only write to analogout when there is a change in aoVal
    {
      analogWrite(condaoPin[thisCondIndex], currentaoVal);
      lastcurrentaoVal = currentaoVal;
      if (bdebug)
      {Serial.println(String(indexInSession) + '\t' + String(currentaoVal) + '\t' + String(long(condamp[thisCondIndex]))+ '\t' + String(condaoval));
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
void task()
{
 
  // Run state machine
  switch (state) {

  case 22: // state_0 state
  // THis is a hack it is not clear why this timer needs to be reset each time
     TCCR5B = (TCCR5B & 0xF8) | 0x01;                         // set Timer to 32kHz //http://sobisource.com/?p=195 
     
     indexInSession++;
     if (indexInSession == sizeStimCondBlock){ // switch to using the premature block cause regular block is finished
         indexInSession = 0;
      } 
     thisCondIndex =  sessioncond[indexInSession];     
     condThisTrial[thisCondIndex] = 0 ; // not relavent to interval Stimulation
   
   if (bdebug)
  {// TROUBLESHOOT    Serial.println(String(indexInSession) + '\t' +  String(stimIndex));// BA
    Serial.println(  String(indexInSession) + '\t'+ String(sessioncond[indexInSession]) + '\t' +  String(long(condamp[thisCondIndex])) + '\t' +  String(onStateTrigger[thisCondIndex]));
  }
     Serial.print(61); Serial.print("\t"); Serial.println(millis());
     digitalWrite(syncLed,LOW);
     delay(50);
     Serial.print(62); Serial.print("\t"); Serial.println(millis());
     digitalWrite(syncLed,HIGH);

     trialNum++;

     Serial.print(3); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledC,LOW);
     
      while(Serial.read() != 115){
  }
     state = 31; //23;
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
     
     if (bwaterreward)
     {
       Serial.print(6); Serial.print("\t"); Serial.println(millis());
       digitalWrite(valvL,HIGH);
       delay(timeValvL);
       Serial.print(14); Serial.print("\t"); Serial.println(millis());
       digitalWrite(valvL,LOW);
     }
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 31: // water_R state
     Serial.print(12); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledL,HIGH);
     Serial.print(13); Serial.print("\t"); Serial.println(millis());
     digitalWrite(ledR,HIGH);

     if (bwaterreward)
     {
       Serial.print(7); Serial.print("\t"); Serial.println(millis());
       digitalWrite(valvR,HIGH);
       delay(timeValvR);
       Serial.print(15); Serial.print("\t"); Serial.println(millis());
       digitalWrite(valvR,LOW);
     }
     state = 32;
     Serial.print(state); Serial.print("\t"); Serial.println(millis());
     break;
    
    case 32: // ITI state
     if((millis()-swTrialOn)>ITI){
       state = 22;
       Serial.print(state); Serial.print("\t"); Serial.println(millis());
     }
     break;
  }
}
/*==============================================================================
 * SETUP FUNCTIONS()
 *============================================================================*/

void setupStimulation()
{
   //Setup AO and condition varuables
  TCCR5B = (TCCR5B & 0xF8) | 0x01;                     // set Timer 5 to 32kHz //http://sobisource.com/?p=195 
  for (  int i  = 0; i < ncond ; i++){ 
    pinMode(condaoPin[i], OUTPUT);                             // sets the pin as output
    analogWrite(condaoPin[i], 127);
    pinMode(condstimPin[i], OUTPUT);                             // sets the pin as output
    digitalWrite(condstimPin[i],HIGH);
    condPIN_Status[i] = 0;
    condThisTrial[i] = 0;
    lastPulseHigh[i] = 0; 
    condlastStepAt[i]= 0;
    condstepintv_Up[i] = conddur_rampUp[i]/(255/condRAMPSTEP[i]); 
    condpulseinterval[i] = 1000/condpulsefreq[i]; 
  }
  delay(500); // FLASH Stim PINs for half a sec
   for (  int i  = 0; i < ncond ; i++){ 
   digitalWrite(condstimPin[i],LOW);
   analogWrite(condaoPin[i], 0);
 
   }
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
  indexInSession = -1;  // reinitialize block counter (for trials in entire session)

  // Create condition block 
  for ( i  = 0; i < condblockSize ; i++){
    condBlock[i] = -1;  // by default the entire block is no stimulation
  }
  for ( i  = 0; i < ncond ; i++){ // fill condition block with parts of the block
    for ( j  = 0; j < sizeInCondBlock[i] ; j++){
      condBlock[index] = i; 
      index++;
    }
  }
   if (bdebug)
   {//BA TROUBLESHOOT
        for ( j  = 0; j < condblockSize; j++){
          Serial.println(String( condBlock[j])); // trial stimulus
         }
       Serial.println(String(sizeStimCondBlock));
   }
  if(brandomizeBlock){
    //
    for ( i  = 0; i < condblockSize ; i++){
      for ( j  = 0; j < sizeStimSetInd; j++){
        sessionstim[i*sizeStimSetInd+j] = j; // trial stimulus
        sessioncond[i*sizeStimSetInd+j] = condBlock[i];  //trial condition
      }
    }
    bubbleUnsort2d((int*) sessionstim, (int*) sessioncond, sizeStimCondBlock);
  }
  else // stimulate in blocks
  {
     int stimBlock[sizeStimSetInd];
    for ( j  = 0; j < sizeStimSetInd; j++){
      stimBlock[j] = stimSetInd[j];
    }
    //
    for ( i  = 0; i < condblockSize ; i++){
       bubbleUnsort((int*) stimBlock, sizeStimSetInd) ;
      for ( j  = 0; j < sizeStimSetInd; j++){
        sessionstim[i*sizeStimSetInd+j] = stimBlock[j]; // trial stimulus
        sessioncond[i*sizeStimSetInd+j] = condBlock[i];
      }
    }
     
  }
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

void stimulationOnOff()
{// Turn on Stimulation Pin
  if( timeonDelay != -1 && onDelay[thisCondIndex] != -1 && (millis() - timeonDelay ) > onDelay[thisCondIndex]){
    digitalWrite(condstimPin[thisCondIndex],HIGH);
    condPIN_Status[thisCondIndex] = 1;
    condthisrampstep[thisCondIndex] = condRAMPSTEP[thisCondIndex];
    timeonDuration = millis();
    strToPrint = String(85+thisCondIndex) + '\t' + String(millis());
    Serial.println(strToPrint);
    timeonDelay = -1;
  } 
  // Turn off Stimulation Pin because duration is reached
  else if( timeonDuration != -1 && (millis() - timeonDuration ) > onDuration[thisCondIndex]){
    digitalWrite(condstimPin[thisCondIndex],LOW);
    condPIN_Status[thisCondIndex] = 0;
    condthisrampstep[thisCondIndex] = condRAMPSTEP[thisCondIndex]*-1;
    strToPrint = String(88+thisCondIndex) + '\t' + String(millis()) + '\t' + String(timeonDuration ) + '\t' + String(onDuration[thisCondIndex]) + '\t' + String(thisCondIndex) + '\t' + String(indexInSession);
    strToPrint = String(88+thisCondIndex) + '\t' + String(millis());
    Serial.println(strToPrint);
    timeonDuration = -1;
  }
  // Turn off Stimulation Pin because Delay off is reached NOT TESTED
  else if( timeoffDelay != -1 && (millis() - timeoffDelay ) > offDelay[thisCondIndex]){
    digitalWrite(condstimPin[thisCondIndex],LOW);
    condPIN_Status[thisCondIndex] = 0;
    condthisrampstep[thisCondIndex] = condRAMPSTEP[thisCondIndex]*-1;
    strToPrint = String(88+thisCondIndex)  + '\t' + String(millis());
    Serial.println(strToPrint);
    timeoffDelay = -1;
    timeonDuration = -1;
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
          Serial.println(String(197)+ '\t' + String(condaoval));
          condaoval = 0 ;
          condthisrampstep[thisCondIndex] = 0;
        }
          if (bdebug) 
        {  Serial.println(String(198) + '\t' + String(condaoval));// TROUBLESHOOT
        }
      }
    }
 
  if (bdebug) 
  {  Serial.println(String(199) + '\t' + String(condaoval)+ '\t' + String(condthisrampstep[thisCondIndex]));// TROUBLESHOOT
  }

}

void pulsePWM()
{
  if  (thisCondIndex !=-1) // pulse is undefined for default condition
  {
      if (condpulsefreq[thisCondIndex]!=-1 ) // check if this condition isi pulsed
      {  
        if ((millis()-lastPulseHigh[thisCondIndex]) >= condpulseinterval[thisCondIndex])
        {  currentaoVal = condaoval;
            lastPulseHigh[thisCondIndex] = millis();  
             Serial.println(String(997));
        }
        if (currentaoVal!=0 && (millis()-lastPulseHigh[thisCondIndex]) >= condpulsewidth[thisCondIndex])
        { currentaoVal = 0;
        Serial.println(String(998));
        }
     
      }
      else{ currentaoVal = condaoval;
    Serial.println(String(996));}
      
      if (bdebug) 
      {         Serial.println(String(999) + '\t' + String(condaoval) + '\t' + String(currentaoVal) + '\t' +  String(condpulsewidth[thisCondIndex])+ '\t' +  String(condpulseinterval[thisCondIndex]) + '\t' +  String(lastPulseHigh[thisCondIndex]));
      }
    }
  
}


