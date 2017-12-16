import processing.serial.*;
Serial myPort;  // Create object from Serial class

void setup()  
{
   size(512, 512);
   printArray(Serial.list());
   myPort = new Serial(this,"/dev/ttyACM0", 9900, 'N', 8, 2.0);
}

void draw()
{
  float percentage = map(mouseX, 0, 512, 0, 1);
  background(percentage);
   
   myPort.write(0xFF); 
   myPort.write(0x09);
   myPort.write(1);
   
   delay(40);
}