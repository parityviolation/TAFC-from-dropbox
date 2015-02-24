/* Stimulation at an interval
Bassam V Atallah, April 2013  */
 


// PinOut 
int aoPIN = 9;
int stimPIN[] = {22,23,24};
// Cond Parameters (Designed for Cond of Light Stimulation)

const int ncond = 3;
const int condblockSize = 3;
boolean brandomizeBlock = 0;         // set to 0 for stimulation in blocks 
int  sizeInCondBlock[] = {
  1,1,1};
int onDelay[]  = {
  0,0,0};
int onDuration[]  = {
  5000,5000,5000};     // time in ms  //NOTE: duration includes the ramp up (but not the ramp down)
const boolean bintervalStimulation = 1;
const unsigned long stimInterval = 15000 ; // this is max interval for random interval time in ms (set to -1 if using onStateTrigger)
const unsigned long minstimInterval = 6500; // used for random interval
const boolean brandstimInterval = 0 ; // time in ms (set to -1 if using onStateTrigger)
//int onStateTrigger[]  = {
//  -1,-1,-1};       
int offDelay[]  = {
  0,0,0};
int offStateTrigger[]  = {
  -1,-1,-1};                         // This can be any state number, -1 means this trigger will not be used
// Analogout setup
const int condstimPin[] = {
  stimPIN[0],stimPIN[1],stimPIN[2]};                       // output pin to signal that laser is on
int condaoPin[] = {
  aoPIN,aoPIN,aoPIN};                       // output pin supporting PWM
unsigned long conddur_rampUp[] = {
 1500,1500,1500};     // ms ramp rate: define as the time ramp from 
const int condRAMPSTEP[] = {
  1,1,1};                   // step size of change in PWM duty cycle, NOTE: if dur_rampUp is faster than 255 then step size should be increased so that stepintv_Up > 0
int condthisrampstep[] = {
  0,0,0};                   // step size of change in PWM duty cycle, NOTE: if dur_rampUp is faster than 255 then step size should be increased so that stepintv_Up > 0
float condamp[] = {
  63,80,100};                       // percentage of Vcc (usually 5V) NOTE: this doesn't change ramp rate
int condstepintv_Up[ncond] ;
long condaoval[] = {
  0,0,0};
unsigned long condlastStepAt[] = {
  0,0,0};           // ms time of last step
// Pulses?
const int condpulsefreq[] = {-1,-1,-1}; // use -1 if no pulse
const unsigned int condpulsewidth[] = {10,10,10}; 
unsigned long  condpulseinterval[ncond];
unsigned long lastPulseHigh[] = {0,0,0}; // for internal house keeping
unsigned long currentaoVal[]= {0,0,0};   // for internal house keeping 

// Internal Cond Variables
int condBlock[condblockSize];
boolean condPIN_Status = 0;           // is high when the PIN is high
boolean condThisTrial = 0;           // is high if stimulation has occured this trial
unsigned long timeonDelay = -1;
unsigned long timeoffDelay = -1;
unsigned long timeonDuration = -1;
unsigned int thisCondIndex = 0;
boolean btriggerCondOff = 0;          // set high will start off Delay timer ending Stimulation
boolean btriggerCondOn = 0;           // set high will start on Delay timer before Stimulation
unsigned long lastStimulation = 0;        // for Interval Stimulation
unsigned long thisstimInterval= stimInterval;     // for Interval Stimulation
unsigned indexStimulation = 0;

// Internal variables
String strToPrint = String(500) + '\t' + String(millis());



// Configure start/end of session
//int incomingByte;
void (* resetFunc) (void)=0;           // function to restart the protocol

void setup() {
  
    Serial.begin(115200);
while(Serial.read() != 115){
 }
 setupStimulation();
 createCondBlock();
 
  
}

void loop() {

  // Update Stimulation PINS
  intervalStimulationCounter();
  stimulationTriggerHelper();
  stimulationOnOff();
  rampPWM();
  pulsePWM();
  
  analogWrite(condaoPin[thisCondIndex], currentaoVal[thisCondIndex]);

 
}

void stimulationOnOff()
{// Turn on Stimulation Pin
  if( timeonDelay != -1 && onDelay[thisCondIndex] != -1 && (millis() - timeonDelay ) > onDelay[thisCondIndex]){
    digitalWrite(condstimPin[thisCondIndex],HIGH);
    condPIN_Status = 1;
    condthisrampstep[thisCondIndex] = condRAMPSTEP[thisCondIndex];
    timeonDuration = millis();
    strToPrint = String(300) + '\t' + String(millis()) + '\t' + String(indexStimulation) + '\t' + String(thisCondIndex) + '\t' + String(int(condamp[thisCondIndex])) + '\t' + String(onDuration[thisCondIndex]) + '\t' + String(condpulsefreq[thisCondIndex])  +'\t' + String(condpulsewidth[thisCondIndex]);
    Serial.println(strToPrint);
    timeonDelay = -1;
  } 
  // Turn off Stimulation Pin because duration is reached
  else if( timeonDuration != -1 && onDuration[thisCondIndex] != -1 && (millis() - timeonDuration ) > onDuration[thisCondIndex]){
    digitalWrite(condstimPin[thisCondIndex],LOW);
    condPIN_Status = 0;
    condthisrampstep[thisCondIndex] = condRAMPSTEP[thisCondIndex]*-1;
    //strToPrint = String(88+thisCondIndex) + '\t' + String(millis()) + '\t' + String(timeonDuration ) + '\t' + String(onDuration[thisCondIndex]) + '\t' + String(thisCondIndex) + '\t' + String(indexInSession);
    strToPrint = String(400) + '\t' + String(millis());
    Serial.println(strToPrint);
    timeonDuration = -1;
  }
  // Turn off Stimulation Pin because Delay off is reached NOT TESTED
  else if( timeoffDelay != -1 && offDelay[thisCondIndex] != -1 && (millis() - timeoffDelay ) > offDelay[thisCondIndex]){
    digitalWrite(condstimPin[thisCondIndex],LOW);
    condPIN_Status = 0;
    condthisrampstep[thisCondIndex] = condRAMPSTEP[thisCondIndex]*-1;
    strToPrint = String(400+thisCondIndex)  + '\t' + String(millis());
    Serial.println(strToPrint);
    timeoffDelay = -1;
    timeonDuration = -1;
  }

}

void stimulationTriggerHelper()
{
//  // handle case where State Triggers Stimulation ON/OFF
//  if(condThisTrial  == 0 && condPIN_Status == 0 && state == onStateTrigger[thisCondIndex])
//  {
//    btriggerCondOn =1;
//  }
//
//  if(condPIN_Status == 1 && state == offStateTrigger[thisCondIndex])
//  {
//     btriggerCondOff =1
//  }
  
  // actually start the counter
  if ( btriggerCondOn)
  {timeonDelay = millis();
  btriggerCondOn =0;
  }
  
  if ( btriggerCondOff)
  {timeoffDelay = millis();
  btriggerCondOff =0;
  }
}




void createCondBlock()
{ // this creates an a stimulation block
  // containing the number of instances of each consition in the block that are specified in sizeInCondBlock
  // e.g. blockSize = 10 and sizeInCondBlock = {3,2,-1};  then 
  //               stimulationBlock = {0,0,0,1,1,-1,-1,-1,-1,-1};
  // -1 means no stimulation
  int index = 0;
  int i;
  int j;
  
  indexStimulation = 0 ;  // reinitialize block counter
  // by default the entire block is no stimulation
  for ( i  = 0; i < condblockSize ; i++){
    condBlock[i] = -1; 
  }
  
  for ( i  = 0; i < sizeof(sizeInCondBlock)/sizeof(int) ; i++){
    for ( j  = 0; j < sizeInCondBlock[i] ; j++){
       condBlock[index] = i; 
         index++;
    }
  }
    
   if(brandomizeBlock){
      bubbleUnsort(condBlock, condblockSize);
    }   
    for (i = 0; i<condblockSize; i++)
    {
    strToPrint = String(condBlock[index]);
    Serial.println(strToPrint);

    }

}

void bubbleUnsort(int *list, int elem) //Fisher Yates Shuffle http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
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

void setupStimulation()
{
  for (int i = 0; i<ncond; i++)
  { condpulseinterval[i] = 1000/condpulsefreq[i];

    pinMode(condstimPin[i],OUTPUT); 
    digitalWrite(condstimPin[i],HIGH);
  }
  pinMode(0,INPUT);
  randomSeed(analogRead(0));
 

  //Setup AO
  TCCR2B = (TCCR2B & 0xF8) | 0x01;                     // set Timer 5 to 32kHz //http://sobisource.com/?p=195 
  for (  int i  = 0; i < ncond ; i++){ 
   pinMode(condaoPin[i], OUTPUT);                             // sets the pin as output
   analogWrite(condaoPin[i], 255);
    condstepintv_Up[i] = max(1,conddur_rampUp[i]/(255/condRAMPSTEP[i]));
  }
}
void intervalStimulationCounter()
{
 
 thisCondIndex =  condBlock[indexStimulation]; 
         
         
  if (bintervalStimulation)// check if this condition isi pulsed
  {  
    if ((millis()-lastStimulation) >= thisstimInterval)
    {     
//         strToPrint = String(200+thisCondIndex) + '\t' + String(millis()) + '\t' + String(condthisrampstep[thisCondIndex]);
//    Serial.println(strToPrint);

       btriggerCondOn =1; // Trigger Stimulation (for Stimulation Helper to take care of)     
        lastStimulation = millis();
        
        if (brandstimInterval) // NOTE: interval is not complete random: It can't be short than the Duration of stimulation
        { thisstimInterval = minstimInterval + random(onDuration[thisCondIndex]+10,stimInterval-minstimInterval);}
        
         indexStimulation ++;
         if (indexStimulation == (condblockSize))
         { createCondBlock();
         indexStimulation = 0;}
    }
    
  }
         
}
void pulsePWM()
{
  if (condpulsefreq[thisCondIndex]!=-1) // check if this condition isi pulsed
  {  
    if ((millis()-lastPulseHigh[thisCondIndex]) >= condpulseinterval[thisCondIndex])
    {  currentaoVal[thisCondIndex] = condaoval[thisCondIndex];
        lastPulseHigh[thisCondIndex] = millis();
    }
    if (currentaoVal[thisCondIndex]!=0 && (millis()-lastPulseHigh[thisCondIndex]) >= condpulsewidth[thisCondIndex])
    { currentaoVal[thisCondIndex] = 0;
    }
  }
  else{ currentaoVal[thisCondIndex] = condaoval[thisCondIndex];}
}
void rampPWM()
{ 
  if ( condthisrampstep[thisCondIndex] != 0){
    // ramp up
    if (millis()>(condlastStepAt[thisCondIndex]+condstepintv_Up[thisCondIndex])){
      condlastStepAt[thisCondIndex] = millis();
      condaoval[thisCondIndex] = condaoval[thisCondIndex]+condthisrampstep[thisCondIndex];
    }
    // check if zero/ amplitude has been reached.
    if( condaoval[thisCondIndex] >=(int(255*(condamp[thisCondIndex]/100)))){
      condaoval[thisCondIndex] = (int(255*(condamp[thisCondIndex]/100)));
      condthisrampstep[thisCondIndex] = 0;
    }
    if( condaoval[thisCondIndex] <= 0) {
      condaoval[thisCondIndex] = 0 ;
      condthisrampstep[thisCondIndex] = 0;
    }
 //      strToPrint = String(100+thisCondIndex) + '\t' + String(millis()) + '\t' + String(currentaoVal[thisCondIndex]);
 //   Serial.println(strToPrint);

    //Serial.println(String(condaoval[thisCondIndex]));
    //    Serial.println();
  }

}




