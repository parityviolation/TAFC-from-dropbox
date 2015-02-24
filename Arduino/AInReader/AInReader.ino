int pin = 60;
int V;

void setup(){
  Serial.begin(115200);
  while(Serial.read() != 115){
  }
}

void loop(){
  V = analogRead(pin);
  Serial.println(String(V)) ;
  delay(100);
}
