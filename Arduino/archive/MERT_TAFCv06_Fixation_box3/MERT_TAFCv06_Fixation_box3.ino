//--------------------------Parameters-----------------------------------
//Buttons
int pkR = 11;
int pkC = 8;
int pkL = 5;
//Valves
const int timeValvL = 60;                     // Calibrate valves for 2.58 ul with 50
const int timeValvR = 60;                 // Calibrate valves for 3.66 ul with 50
const int valvL = 7;
const int valvR = 4;
//LEDs
int ledL = 6;
int ledR = 12;
int ledC = 9;
int syncLed = 2;

const int spkr = 3;
int ITI = 9000; // (ms)
int choiceDeadline = 8000; // (ms) 
int timeOut = 6000; // (ms)

//Miscellanious
String strToPrint;
const double initSet[] = {0.2, 0.35, 0.42, 0.46, 0.54, 0.58, 0.65, 0.8};
//const int stimSetInd[] =  {0};
//const int stimSetInd[] =  {0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7};
const int stimSetInd[] =  {0,1,2,3,4,5,6,7};
const int scaling = 3000; // (ms)
const int sizeStimSetInd = sizeof(stimSetInd)/sizeof(const int);
const int bound = scaling/2;
//-----------
int error[sizeof(initSet)/sizeof(const double)];
int input = 0;
int state;
int trialNum = 0;
int stimCurrent;
int stimIndex;
int stimSet[sizeof(initSet)/sizeof(const double)];

unsigned long swTrialOn;
unsigned long swRwdOn;
unsigned long swError;
unsigned long swPkIn;


boolean stimLong;
boolean breDraw = 1; // Redraw this trial
boolean bsessionPM = 0;                    // is set to 1 when PM stimuli are being represented

boolean valuePkC;
boolean valuePkL;
boolean valuePkR;
boolean valuePkCnow;
boolean valuePkLnow;
boolean valuePkRnow;
//-------------------------------------------------------------------

//----------------------------SETUP-----------------------------------
// the setup routine runs once when you press reset:
void setup() { 
//INPUTS  
  pinMode(pkR, INPUT);
  pinMode(pkC, INPUT);
  pinMode(pkL, INPUT);  
//OUTPUTS
  pinMode(ledL, OUTPUT);
  pinMode(ledC, OUTPUT);
  pinMode(ledR, OUTPUT);
  pinMode(syncLed, OUTPUT);
  pinMode(spkr,OUTPUT);
  pinMode(valvL,OUTPUT);
  pinMode(valvR,OUTPUT);
  // initialize LEDs

  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,HIGH);
  digitalWrite(syncLed,HIGH);
  
  
  // setup stimSet
  for (int i=0; i<(sizeof(initSet)/sizeof(double)); i++){
    stimSet[i] = int(initSet[i] * scaling);
    error[i] = 0;
  }
  
//initialize serial port
  Serial.begin(115200);
  while(Serial.read() != 115){
  }
  strToPrint = String(70) + '\t' + String(millis());
  Serial.println(strToPrint);
  state = 22; //state_0 state


  
}
//-------------------------------------------------------------------
//---------------------MAIN LOOP-------------------------------------
// the loop routine runs over and over again forever:
void loop() {
  updatePokes();
  Task();
}
//-------------------------------------------------------------------
//---------------------------Functions-------------------------------
void Task() {
  switch (state) {
    case 22: // state_0 state
    // THis is a hack it is not clear why this timer needs to be reset each time
    TCCR5B = (TCCR5B & 0xF8) | 0x01;
    // set Timer to 32kHz //http://sobisource.com/?p=195 
    
    updateStimCond();
    
    strToPrint = String(61) + '\t' + String(millis()); //syncLED on
    Serial.println(strToPrint);
    digitalWrite(syncLed,LOW);
    delay(100);
    strToPrint = String(62) + '\t' + String(millis()); //syncLED off
    Serial.println(strToPrint);
    digitalWrite(syncLed,HIGH);
    trialNum++;
    
    stimCurrent = stimSet[stimIndex];
    stimLong = (stimCurrent > bound);
    
    digitalWrite(ledC,LOW); // turn led on
    Serial.println(String(3) + '\t' + String(millis()));
    
    state = 23;
    
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    break;
    
  case 23: // wait_Cin state
    if (valuePkC) {
       swTrialOn = millis();
       swPkIn = swTrialOn;
       strToPrint = String(16) + '\t' + String(millis());
       Serial.println(strToPrint);
       tone(spkr,7000,150);
       strToPrint = String(19) + '\t' + String(millis());
       Serial.println(strToPrint); 
       state = 73;
       Serial.println(String(state) + '\t' + String(millis()));
     }
    break;
    
    case 25: // wait_Sin state
     if((millis()-swTrialOn)>choiceDeadline){
       state = 40;
       Serial.println(String(state) + '\t' + String(millis()));
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

    case 26: // rewarded_Lin state
     state = 30;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 27: // unrewarded_Rin state
     swError = millis();
     state = 34;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
    
    case 28: // rewarded_Rin state
     state = 31;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
     
    case 29: // unrewarded_Lin state
     swError = millis();
     state = 34;
     Serial.println(String(state) + '\t' + String(millis()));
     break;
      
    case 30: // water_L state
      Serial.println(String(12) + '\t' + String(millis()));
      digitalWrite(ledL,HIGH);
      Serial.println(String(13) + '\t' + String(millis()));
      digitalWrite(ledR,HIGH);
      
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
      Serial.println(String(12) + '\t' + String(millis()));
      digitalWrite(ledL,HIGH);
      Serial.println(String(13) + '\t' + String(millis()));
      digitalWrite(ledR,HIGH);
      
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
         {digitalWrite(spkr,HIGH);}
       else
         {digitalWrite(spkr,LOW);}
     }
     Serial.println(String(36) + '\t' + String(millis()));
     state = 33;
     Serial.println(String(state) + '\t' + String(millis()));
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
    
    case 73: // stay_Cin state
   if((millis()-swPkIn)>stimCurrent){

     digitalWrite(ledC,HIGH);
     Serial.println(String(11) + '\t' + String(millis()));
     digitalWrite(ledL,LOW);
     Serial.println(String(4) + '\t' + String(millis()));
     digitalWrite(ledR,LOW);
     Serial.println(String(5) + '\t' + String(millis()));
     Serial.println(String(17) + '\t' + String(millis()));
     tone(spkr,7000,150);
     Serial.println(String(20) + '\t' + String(millis()));
     state = 25;
     Serial.println(String(state) + '\t' + String(millis()));
   }
   else{
     if(valuePkC==false){
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
//-------------------------------------------------------------------
//---Setting the Intervals (2nd beep)----------------------------------
void updateStimCond()
{  
stimIndex = stimSetInd[random(sizeStimSetInd)];
}
//-------------------------------------------------------------------
