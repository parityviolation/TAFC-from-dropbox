int valvL = 13;
int ledL = 6;
int ledR = 12;
int valvR = 7;

void setup(){
  pinMode(ledL,OUTPUT);
  pinMode(valvL,OUTPUT);
  pinMode(ledR,OUTPUT);
  pinMode(valvR,OUTPUT);
}

void loop(){
  digitalWrite(ledL,LOW);
  digitalWrite(valvL,HIGH);
  digitalWrite(ledR,HIGH);
  digitalWrite(valvR,LOW);
  delay(200);
  digitalWrite(ledL,HIGH);
  digitalWrite(valvL,LOW);
  digitalWrite(ledR,LOW);
  digitalWrite(valvR,HIGH);
  delay(200);
}
