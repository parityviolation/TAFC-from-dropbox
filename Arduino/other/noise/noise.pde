int spkr = 3;

void setup(){
  pinMode(spkr,OUTPUT);
}

void loop(){
  if (random(2) == 1)
  {
    digitalWrite(spkr,HIGH);
  }
  else
  {
    digitalWrite(spkr,LOW);
  }
}
