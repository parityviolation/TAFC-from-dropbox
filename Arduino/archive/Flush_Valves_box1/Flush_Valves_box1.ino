int valvL = 30;
int ledL = 6;
int ledR = 12;
int valvR = 4;
int valvTimeL = 52;
int valvTimeR = 200;
int state = 0;
int ledC = 9;
int syncLed = 2;

void setup(){
  pinMode(syncLed,OUTPUT);
  pinMode(ledL,OUTPUT);
  pinMode(valvL,OUTPUT);
  pinMode(ledR,OUTPUT);
  pinMode(valvR,OUTPUT);
  pinMode(ledC,OUTPUT);
  digitalWrite(ledC,HIGH);
  digitalWrite(syncLed,HIGH);
}

void loop(){
  switch (state){
    case 0:
    for(int i = 0; i<3 ; i++){
      // LEFT
      digitalWrite(ledL,LOW);
      digitalWrite(valvL,HIGH);
      delay(valvTimeL);
      digitalWrite(ledL,HIGH);
      digitalWrite(valvL,LOW);

      // RIGHT
      digitalWrite(ledR,LOW);
      digitalWrite(valvR,HIGH);
      delay(valvTimeR);
      digitalWrite(ledR,HIGH);
      digitalWrite(valvR,LOW);
      
      delay(1000);
    }
    state = 1;
    break;
    case 1:
    break;
  }
}
