/* Interval duration discrimination task
 Thiago Gouvea, Learning lab, Nov 2012 */
const int sizeStimSetInd = 2 ;  // must be the same size as the array stimSetInd
int stimSet[] = {
  1050, 1950};
int stimSetInd[] =  {
  0,1};
int bound = 1500;
int ITI = 9000;
int timeOut = 18000;
int choiceDeadline = 5000; 
int timeValvL = 70; // Calibrate valves for 2.58 ul with 50
int timeValvR = 140; // Calibrate valves for 2.66 ul with 50
int clThre = 3; // Threshold to activate correction loops, exclusive
int clCredit = 1; // Decrement in error counter for each correct trial (but never goes negative)

// Cond Parameters (Designed for Cond of Light Stimulation)
int  sizeInCondBlock[] = {
  3,2,0};
int onDelay[]  = {
  1000,2000,0};
int onDuration[]  = {
  3000,1000,0}; // time in ms 
int onTrigger[]  = {
  56,56,-1}; // This can be any state number, -1 means this trigger will not be used
int offDelay[]  = {
  0,0,0};
int offTrigger[]  = {
  -1,-1,-1}; // This can be any state number, -1 means this trigger will not be used
// Internal Cond Variables
const int condblockSize = 6;
int condBlock[condblockSize];
boolean condPIN_Status = 0; // is high when the PIN is high
boolean condThisTrial = 0; // is high if stimulation has occured this trial
unsigned long timeonDelay = -1;
unsigned long timeoffDelay = -1;
unsigned long timeonDuration = -1;
boolean thisCondIndex = 0;
boolean brandomizeBlock = 1; // set to 0 for stimulation in blocks 

const int minTrialsInBlock = 50;  // the stimcondblock must contain at least this number of trials
const int sizeStimCondBlock = condblockSize*sizeStimSetInd;
int sessioncond[sizeStimCondBlock];
int sessionstim[sizeStimCondBlock];
int indexInBlock;
int sessioncondPM[sizeStimCondBlock]; // array for holding stimuli / cond where animal was premature.. these will be added first when the session repeats
int sessionstimPM[sizeStimCondBlock]; // array for holding stimuli / cond where animal was premature.. these will be added first when the session repeats
int indexInBlockPM;
boolean bsessionPM = 0;
int nPM = 0;


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
  0, 0, 0, 0, 0, 0, 0, 0};
boolean stimLong;
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
int condPIN = 2 ; // 


// Configure start/end of session
//int incomingByte;
void (* resetFunc) (void)=0; // function to restart the protocol

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

  pinMode(condPIN,OUTPUT);

  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,HIGH);
  digitalWrite(syncLed,HIGH);
  digitalWrite(valvL,LOW);
  digitalWrite(valvR,LOW);

  digitalWrite(condPIN,HIGH);


  Serial.begin(115200);
  while(Serial.read() != 115){
  }

  clearsessionPM();
  createStimCondBlock();

  state = 22;
  strToPrint = String(state) + '\t' + String(millis());
  Serial.println(strToPrint);
  // strToPrint = String(state) + '\t' + String(millis());;
}

void clearsessionPM()
{
    for (int i = 0; i < sizeStimCondBlock; i++){
    sessioncondPM[i] = -1;
    sessionstimPM[i] = -1;
    }
}
void stimulationOnOff()
{// Turn on Stimulation Pin
  if( timeonDelay != -1 && onDelay[thisCondIndex] != -1 && (millis() - timeonDelay ) > onDelay[thisCondIndex]){
    digitalWrite(condPIN,LOW);
    condPIN_Status = 1;
    timeonDuration = millis();
    strToPrint = String(63) + '\t' + String(millis());
    Serial.println(strToPrint);
    timeonDelay = -1;
  } 
  // Turn off Stimulation Pin because duration is reached
  if( timeonDuration != -1 && onDuration[thisCondIndex] != -1 && (millis() - timeonDuration ) > onDuration[thisCondIndex]){
    digitalWrite(condPIN,HIGH);
    condPIN_Status = 0;
    strToPrint = String(64) + '\t' + String(millis()) + '\t' + String(timeonDuration ) + '\t' + String(onDuration[thisCondIndex]) + '\t' + String(thisCondIndex) + '\t' + String(indexInBlock);
    Serial.println(strToPrint);
    timeonDuration = -1;
  }
    // Turn off Stimulation Pin because Delay off is reached NOT TESTED
  if( timeoffDelay != -1 && offDelay[thisCondIndex] != -1 && (millis() - timeoffDelay ) > offDelay[thisCondIndex]){
    digitalWrite(condPIN,HIGH);
    condPIN_Status = 0;
    strToPrint = String(64)  + '\t' + String(millis());
    Serial.println(strToPrint);
    timeoffDelay = -1;
    timeonDuration = -1;
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
  
  indexInBlock = 0;  // reinitialize block counter (for trials in entire session)
  
  
  // Create condition block 
  for ( i  = 0; i < condblockSize ; i++){
    condBlock[i] = -1;  // by default the entire block is no stimulation
  }
  for ( i  = 0; i < sizeof(sizeInCondBlock)/sizeof(int) ; i++){ // fill condition block with parts of the block
    for ( j  = 0; j < sizeInCondBlock[i] ; j++){
         condBlock[index] = i; 
         index++;
    }
  }
  
  if(brandomizeBlock){
  //
   for ( i  = 0; i < condblockSize ; i++){
    for ( j  = 0; j < sizeStimSetInd; j++){
      sessionstim[i*sizeStimSetInd+j] = j; // trial stimulus
    sessioncond[i*sizeStimSetInd+j] = i;  //trial condition
    }
  }
      bubbleUnsort2d((int*) sessionstim, (int*) sessioncond, sizeStimCondBlock);
   }
   else // stimulate in blocks
   {
  //
   for ( i  = 0; i < condblockSize ; i++){
    for ( j  = 0; j < sizeStimSetInd; j++){
      sessionstim[i*sizeStimSetInd+j] = j; // trial stimulus
      sessioncond[i*sizeStimSetInd+j] = condBlock[i];
    }
   }
   bubbleUnsort((int*) sessionstim, sizeStimCondBlock) ; 
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


void stimulationTriggerHelper()
{
  if(condThisTrial  == 0 && condPIN_Status == 0 && state == onTrigger[thisCondIndex])
  {
    timeonDelay = millis();
  }

  if(condPIN_Status == 1 && state == offTrigger[thisCondIndex])
  {
    timeoffDelay = millis();
  }
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

  // Update Stimulation PINS
  stimulationTriggerHelper();
  stimulationOnOff();

  // Run state machine
  switch (state) {

  case 22: // state_0 state
     condThisTrial = 0 ; 
      if((indexInBlock == (sizeStimCondBlock-1)) & !bsessionPM ){ // switch to using the premature block
        bsessionPM=1;
       indexInBlockPM = -1;
     } 
      
      
      if ((bsessionPM & indexInBlockPM) ){
        indexInBlockPM++;
        thisCondIndex =  sessioncond[indexInBlockPM];
        stimIndex = sessionstim[indexInBlockPM];
        sessioncondPM[indexInBlock] = -1;
        sessionstimPM[indexInBlock] = -1;
        if (stimIndex == -1){ // No more premature trials exist go back to Block
          bsessionPM =0; 
          indexInBlock = -1;
          nPM = 0;
        }
      }
      
      if (!bsessionPM){
         indexInBlock++;
         thisCondIndex =  sessioncond[indexInBlock];
         stimIndex = sessionstim[indexInBlock];
       }
    
    strToPrint = String(61) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(syncLed,LOW);
    delay(100);
    strToPrint = String(62) + '\t' + String(millis());
    Serial.println(strToPrint);
    digitalWrite(syncLed,HIGH);
    trialNum++; 
   
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
    
    state = 30;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 28: // correct_Rin state
    error[stimIndex] = error[stimIndex] - clCredit;
    if(error[stimIndex]<0){
      error[stimIndex] = 0;
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
   
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 29: // error_Lin state
    swError = millis();
    error[stimIndex]++;
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;

  case 38: // premature_left_poke_in state
    swError = millis();
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    // Save cond and stim in premature 
    sessioncondPM[nPM] = thisCondIndex ;
    sessionstimPM[nPM] = stimIndex;
    nPM++;
    if (nPM == sizeStimCondBlock){
    nPM = 0;}
    break;


  case 39: // premature_right_poke_in state
    swError = millis();
    state = 34;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    
    // Save cond and stim in premature 
    sessioncondPM[nPM] = thisCondIndex ;
    sessionstimPM[nPM] = stimIndex;
    nPM++;
    if (nPM == sizeStimCondBlock){
    nPM = 0;}
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




