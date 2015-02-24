int state = 1;
String strToPrint = String(state) + '\t' + String(millis());

void setup(){
   pinMode(13,OUTPUT);
   pinMode(9,OUTPUT);
   Serial.begin(115200);
}

void loop(){
  
switch(state){
  case 1:
   Serial.println("Case 1. Turning LED off and state becomes 2");
   delay(300);
   digitalWrite(13,LOW);
   digitalWrite(9,HIGH);
   state = 2;
   delay(1000);
   break;
  case 2:
   Serial.println("Case 2. Where do we go now?");
   delay(300);
   if(digitalRead(8)){
    Serial.println("I can feel your nose. Let's go to 1");
    delay(300);
    state = 1;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    delay(300);
  }
  else{
    Serial.println("You're gone. Go to 3.");
    delay(300);
    state = 3;
    strToPrint = String(state) + '\t' + String(millis());
    Serial.println(strToPrint);
    delay(300);
  }
   break;  
  case 3:
   Serial.println("Case 3. LED is going HIGH. Go to 2.");
   delay(300);
   digitalWrite(13, HIGH);
   digitalWrite(9, LOW);
   state = 2;
   strToPrint = String(state) + '\t' + String(millis());
   Serial.println(strToPrint);
   delay(300);
   break;
}
delay(300);
}
