int valvL = 7;
int ledL = 6;
int ledR = 12;
int valvR = 4;
int valvTimeL = 100;
int valvTimeR = 100;
int state = 0;
int ledC = 9;

void setup(){
  pinMode(ledL,OUTPUT);
  pinMode(valvL,OUTPUT);
  pinMode(ledR,OUTPUT);
  pinMode(valvR,OUTPUT);
  pinMode(ledC,OUTPUT);
  digitalWrite(ledC,HIGH);
}

void loop(){
  switch (state){
    case 0:
    for(int i = 0; i<30  ; i++){
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
      
      delay(300);
    }
    state = 1;
    break;
    case 1:
    break;
  }
}
