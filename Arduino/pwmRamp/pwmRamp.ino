
int pwmPin = 9; // output pin supporting PWM
unsigned long dur_rampUp = 2000; // ms
int rampUPstep = 1;
float amp = 100; // fraction of 100
int stepintv_Up = dur_rampUp/(255/rampUPstep);
long valPIN10 = 0;
unsigned long lastStepAt =0;
void setup()
{




  TCCR2B = (TCCR2B & 0xF8) | 0x01; // set Timer 1 to 32kHz (pins 9 and 10) //http://sobisource.com/?p=195
  pinMode(pwmPin, OUTPUT); // sets the pin as output
  analogWrite(pwmPin, 128);
  Serial.begin(115200);
  //  while(Serial.read() != 115){
  //  }
}
void loop()
{

  //volt =(5.0 * val) / 1023;
  //val = 255 * (volt / 5);
  if (millis()>(lastStepAt+stepintv_Up)){
    lastStepAt = millis();
    valPIN10 = valPIN10+rampUPstep;
    if (valPIN10 >= (int(255*(amp/100))))
    {
      valPIN10 = (int(255*(amp/100)));
       rampUPstep =  -1;
    }
    if( valPIN10 <= 0) {
      valPIN10 == 0 ;
      rampUPstep =  1;
    }
  }
  analogWrite(pwmPin, valPIN10);
  Serial.println(valPIN10);



}





