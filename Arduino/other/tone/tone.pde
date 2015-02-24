int spkr = 3;

void setup(){
  pinMode(spkr,OUTPUT);
}

void loop(){
  tone(spkr,5000,3000);
  delay(1000);
  noTone(spkr);
  delay(1000);
}
