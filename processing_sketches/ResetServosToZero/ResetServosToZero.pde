import processing.serial.*;
Serial myPort;  // Create object from Serial class
int servoX;
byte[] serialBytes;
void setup()  
{
   size(512, 512);
   printArray(Serial.list());
   myPort = new Serial(this,"/dev/tty.usbmodem00196521", 9900, 'N', 8, 2.0);
   //myPort.write(0xAA);
//   myPort = new Serial(this,"/dev/tty.usbmodem00196521");
   //myPort.write(0xAA);
   //   myPort.write(0xFF); 
   //myPort.write(0x00);
   //int mappedValue = int(map(mouseX, 0, 512, 112, 140));
   //println(mappedValue);
   //myPort.write(0x7F);
}

int minServoQuarters = 704 * 4;
int maxServoQuarters = 2496 * 4;

void setServoValue(int servo, float percentage) {
   int servoX = int(map(percentage, 0, 1, minServoQuarters, maxServoQuarters));
   if (servo == 0)
     println(servoX);
   
   myPort.write(0x84); 
   myPort.write(servo);
   myPort.write(byte(servoX) & 0x7F); 
   myPort.write(byte(servoX>>7) & 0x7F);
   
   //myPort.write(0xFF); 
   //myPort.write(0x00);
   //myPort.write(int(map(percentage, 0, 1, 0, 254)));
}

int numServos =21;

void draw()
{
  float percentage = map(mouseX, 0, 512, 0, 1);
  background(percentage);
    //delay(1000);
   for(int i = 0; i < numServos; i++) {
     setServoValue(i, percentage);
   }
}