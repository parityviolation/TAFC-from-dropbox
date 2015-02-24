
int pwmPin = 9; // output p supporting PWM
unsigned long dur_rampUp = 2000; // ms
int rampUPstep = 1;
float amp = 100; // fraction of 100
int stepintv_Up = dur_rampUp/(255/rampUPstep);
int pulsewidth = 950; // ms
int pulsefrequency = 1; // Hz
int pulseinterval = 1000/pulsefrequency;
long valPIN10 = 255;
long currentao = valPIN10;
unsigned long lastStepAt =0; //time
unsigned long lastPulseHigh = 0; // time

void setup()
{

  TCCR5B = (TCCR5B & 0xF8) | 0x01; // set Timer 1 to 32kHz (pins 9 and 10) //http://sobisource.com/?p=195
  pinMode(pwmPin, OUTPUT); // sets the pin as output
  analogWrite(pwmPin, 0);
  delay(1000);
  analogWrite(pwmPin, 255);

  Serial.begin(115200);
  //  while(Serial.read() != 115){
  //  }
}
void loop()
{

  //volt =(5.0 * val) / 1023;
  //val = 255 * (volt / 5);
 
  
  if ((millis()-lastPulseHigh) >= pulseinterval)
  {
  valPIN10 = currentao;
  lastPulseHigh = millis();
  }
  if (valPIN10>0 && (millis()-lastPulseHigh) >= pulsewidth)
  {currentao = valPIN10;
  valPIN10 = 0;
  }
  
  
  analogWrite(pwmPin, valPIN10);
  Serial.println(valPIN10);



}





