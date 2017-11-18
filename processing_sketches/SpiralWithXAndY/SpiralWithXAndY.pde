int w = 800;
int h = 800;

import processing.serial.*;

boolean useSerial = false;
// The serial port:
Serial serialPort;       

int design = 1;
int numDesigns = 3;

void settings() {
  size(w, h);
}

int numPoles = 20;
float poleWidth = w * 1.0 / numPoles;
float fullPoleSize = poleWidth * 2;

float[] poleRotations = new float[numPoles];
float[] targetRotations = new float[numPoles];

void resetTargetPoleRotationsTo(float targetRotation) {
  for(int i = 0; i < poleRotations.length; i++){
    targetRotations[i] = targetRotation;
  }
}
PImage design1Image;

void setup() {
  
  //design1Image = loadImage("design1Edges.png");
  for(int i = 0; i < poleRotations.length; i++){
    poleRotations[i] = 0;
  }
  

  if (useSerial) {
    // List all the available serial ports:
    printArray(Serial.list());
    
    // Open the port you are using at the rate you want:
    serialPort = new Serial(this, Serial.list()[2], 9600);
  }
  
  resetTargetPoleRotationsTo(0);
}

float maxDistance = w;

float getTargetRotation(float gaze, boolean notGazing, int pole, long now) {
  if (notGazing) return -1;
  float poleCenter = pole * poleWidth + poleWidth / 2;
  
  float distanceFromGaze = gaze - poleCenter;
  
  long timeSinceGazeStart = now - gazeStart;
  
  float percentFromStart = abs(distanceFromGaze) / maxDistance;
  
  //float wavePercentage =  
  
  float rotation = (gaze - poleCenter) / (w / 4.); 
  
  return -constrain(rotation, -1., 1.);
} 

long start = millis();
PGraphics pg;

void drawDesign0(int pole) {
  pg.fill(0);
  pg.rect(-poleWidth, h * noise(pole - 1), poleWidth, 10.); 
  pg.rect(-poleWidth, h * noise(pole), poleWidth, 10.); 
  pg.rect(-poleWidth, h * noise(pole - 2), poleWidth, 10.); 
  pg.rect(-poleWidth, h * noise(pole - 3), poleWidth, 10.);  
  pg.rect(poleWidth, h * noise(pole + 1), poleWidth, 10.);
  pg.rect(poleWidth, h * noise(pole + 2), poleWidth, 10.);
  pg.rect(poleWidth, h * noise(pole + 3), poleWidth, 10.);
  pg.rect(poleWidth, h * noise(pole + 4), poleWidth, 10.);
}

void drawDesign1(int pole) {
  pg.stroke(0);
  pg.strokeWeight(5);
  pg.line(-poleWidth/2, h, poleWidth + poleWidth/2, 0);
}

int design2Rows = 6;
float smallRectWidth = 8;
float smallRectHeight = 18;
float cellHeight = h * 1.0 / design2Rows;
void drawDesign2(int pole) {
  
  pg.pushMatrix();
  for(int i = 0; i < design2Rows; i++) {
    pg.noStroke();
    pg.fill(0);
    pg.rect(-smallRectWidth, cellHeight / 2 - smallRectHeight / 2, smallRectWidth, smallRectHeight);
    pg.rect(poleWidth, cellHeight / 2 - smallRectHeight / 2, smallRectWidth, smallRectHeight);
    
    //pg.rect(poleWidth / 2 + smallRectHeight / 2 + poleWidth / 2, cellHeight / 2 - smallRectHeight / 2, smallRectWidth, smallRectHeight);
    pg.translate(0, cellHeight);
    pg.stroke(200.);
    pg.line(0, 0, poleWidth, 0);
  }
  pg.popMatrix();
}

void drawPole(int pole, long time) {
  pg = createGraphics(floor(poleWidth), h);
  pg.beginDraw();
  pg.translate(poleRotations[pole] * poleWidth, 0);
  if (design == 0) {
    drawDesign0(pole); 
  } else if (design == 1) {
    drawDesign1(pole);
  } else if (design == 2) {
    drawDesign2(pole);
  }
  pg.endDraw();
  
  pushMatrix();
  translate(pole * poleWidth, 0);
  image(pg, 0, 0, poleWidth, h);
  popMatrix();
}

float dividerWidth = 5;

void drawDivider(int pole) {
  pushMatrix();
  translate(pole * poleWidth, 0);
  noStroke();
  fill(200);
  rect(poleWidth - dividerWidth / 2., 0, dividerWidth, h);
  popMatrix();
}


float gazeResetDistance = 20;

float lastGazeDirection = -1000;
long gazeStart = millis();



void setTargetRotation(int pole, float gazeX, float gazeY) {
  float poleCenter = pole * poleWidth + poleWidth / 2;
  
  float distanceFromWave = map(gazeX - poleCenter, float(-w), float(w), -PI, PI);
  //print(distanceFromWave);
  //print(" ");
  
  float amplitude = map(gazeY, h, 0, .5, -.5);
  
  float heightAtP = cos(distanceFromWave) * amplitude;
  
    print(heightAtP);
  print(" ");
  //float targetHeight = gazeY - distanceFromGaze;
  
  //float targetRotation = map(distanceFromGaze, 0, gazeY, -0.5, 0.5);
  
  float rotation = heightAtP; 
  //rotation += h / 2 - gazeY;
  
  //rotation = constrain(rotation, -.5, .5);
  targetRotations[pole] = rotation;
}

String getFrameNumber(int frame) {
  if (frame < 10)
    return "0" + frame;
  return "" + frame + "";
}
int frame = 0;

boolean captureTexture = false;

void draw() {
   background(255);
   println("___");
   
   //println(map(mouseY, h, 0, -.5, .5));
   if (captureTexture) {
     pg = createGraphics(floor(fullPoleSize), h);  
     print("drawing desing 1");
     pg.beginDraw();
     pg.background(255);
     pg.translate(poleWidth / 2, 0);
     drawDesign1(0);
     pg.endDraw();
     pg.save("texture.gif");
     image(pg, 0, 0);
     print("drew");
     noLoop();
     return;
   }
   
   long time = millis() - start;
  
   boolean notGazing =  (mouseY > h - 20 || mouseY < 20);
   long now = millis();
   
   for(int i = 0; i < numPoles; i++) {
     setTargetRotation(i, mouseX, mouseY);
   }
   
   for(int i = 0; i < numPoles; i++ ) {
     poleRotations[i] = poleRotations[i] + (targetRotations[i] - poleRotations[i]) / 10.;
   //poleRotations[i] = -0.5;  
 }
 
   
   for(int i = 0; i < numPoles; i++) {
     drawPole(i, time);
   }
   
   for(int i = 0; i < numPoles; i++) {
     drawDivider(i);
   }   
   
  
   //if (frame < 60)
   //  saveFrame("frame-" + getFrameNumber(frame) + ".gif");
   //  frame++;
}

void keyPressed() {
  if(key == TAB) {
    design++;
    if (design >= numDesigns) design = 0;
  }
}