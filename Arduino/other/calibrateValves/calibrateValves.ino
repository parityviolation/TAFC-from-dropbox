int valvL = 7;
int ledL = 6;
int ledR = 12;
int valvR = 4;
int valvTimeL = 60;
int valvTimeR = 60;
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
    for(int i = 0; i<200  ; i++){
      // LEFT
      digitalWrite(ledL,LOW);
      digitalWrite(valvL,LOW);
      delay(valvTimeL);
      digitalWrite(ledL,HIGH);
      digitalWrite(valvL,HIGH);

      // RIGHT
      digitalWrite(ledR,LOW);
      digitalWrite(valvR,LOW);
      delay(valvTimeR);
      digitalWrite(ledR,HIGH);
      digitalWrite(valvR,HIGH);
      
      delay(300);
    }
    state = 1;
    break;
    case 1:
    break;
  }
}
