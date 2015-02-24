int t = 500;

void setup() {
  // put your setup code here, to run once:
  pinMode(7,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(13,OUTPUT);
  pinMode(5,INPUT);
  Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly:
 digitalWrite(7,HIGH);
 digitalWrite(6,HIGH);
 digitalWrite(13,HIGH);
 Serial.println(digitalRead(5));
 delay(t/5);
 digitalWrite(7,LOW);                                                                                                                                                                                                                                                                                                                                         
 digitalWrite(6,LOW);
 digitalWrite(13,LOW);
 Serial.println(digitalRead(5));
 delay(t);
}
