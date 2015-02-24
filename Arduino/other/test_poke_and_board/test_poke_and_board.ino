/* Testing Matthieu's board
turns valve and syncLed on and plays a beep in response to poking
Thiago Gouvea, Aug 2012 */

// PinOut
int syncLed = 0;
int spkr = 1;
int pkR = 11;
int ledR = 12;
int valvR = 7;
int pkL = 5;
int ledL = 6;
int valvL = 13;

void setup() {
  pinMode(syncLed,OUTPUT);
  pinMode(spkr,OUTPUT);
  pinMode(pkR,INPUT);
  pinMode(ledR,OUTPUT);
  pinMode(valvR,OUTPUT);
  pinMode(pkL,INPUT);
  pinMode(ledL,OUTPUT);
  pinMode(valvL,OUTPUT);
}

void loop(){
  if(digitalRead(pkR)){
    digitalWrite(ledR,HIGH);
    digitalWrite(valvR,HIGH);
    tone(spkr,4500,500);
    delay(500);
    digitalWrite(ledR,LOW);
    digitalWrite(valvR,LOW);
  }
  if(digitalRead(pkL)){
    digitalWrite(ledL,HIGH);
    digitalWrite(valvL,HIGH);
    tone(spkr,4500,500);
    delay(500);
    digitalWrite(ledL,LOW);
    digitalWrite(valvL,LOW);
  }
}
    
