int state = 1;

void setup(){
   pinMode(13,OUTPUT);
   pinMode(9,OUTPUT);
   Serial.begin(115200);
}

void loop(){
  
switch(state){
  case 1:
   Serial.println("Case 1. Turning LED off and state becomes 2");
   digitalWrite(13,LOW);
   digitalWrite(9,HIGH);
   state = 2;
   delay(1000);
   break;
  case 2:
   Serial.println("Case 2. Where do we go now?");
   delay(1);
   if(digitalRead(8)){
    Serial.println("I can feel your nose. Let's go to 1");
    state = 1;
  }
  else{
    Serial.println("You're gone. Go to 3.");
    state = 3;
  }
   break;  
  case 3:
   Serial.println("Case 3. LED is going HIGH. Go to 2.");
   digitalWrite(13, HIGH);
   digitalWrite(9, LOW);
   state = 2;
   delay(1);
   break;
}
delay(1);
}
