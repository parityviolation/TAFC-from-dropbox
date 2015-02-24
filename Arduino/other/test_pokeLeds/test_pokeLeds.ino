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

void setup(){
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
}

void loop(){
  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,LOW);
  delay(333);
  digitalWrite(ledL,HIGH);
  digitalWrite(ledC,LOW);
  digitalWrite(ledR,HIGH);
  delay(334);
  digitalWrite(ledL,LOW);
  digitalWrite(ledC,HIGH);
  digitalWrite(ledR,HIGH);
  delay(333);
}
