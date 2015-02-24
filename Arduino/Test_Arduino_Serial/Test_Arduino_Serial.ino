int timebf = millis();

void setup() {
  // put your setup code here, to run once:
Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly: 


if (millis()-timebf>=5)
{
Serial.println(millis());  
timebf = millis();
}
  
  
}
