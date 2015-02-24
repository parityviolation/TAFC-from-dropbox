
int pwmPin = 45; // output p supporting PWM

int amp = 255; // ms

void setup()
{




  pinMode(pwmPin, OUTPUT); // sets the pin as output
  analogWrite(pwmPin, amp);

}

void loop()
{

}
