void setup(){
  pinMode(1,OUTPUT);
}

void loop(){
  tone(1,7500,300);
  delay(1000);
  noTone(1);
  delay(1000);
}

