int pushButton = 8;

void setup(){
  Serial.begin(9600);
  pinMode(8,INPUT);
}

void loop(){
  int buttonState = digitalRead(pushButton);
  Serial.println(buttonState);
  delay(1);
}
