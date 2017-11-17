int w = 600;
int h = 600;


PShape spiral_column;

PImage img;
int tubeRes = 32;
float[] tubeX = new float[tubeRes];
float[] tubeY = new float[tubeRes];

int numPoles = 20;

float[] poleRotations = new float[numPoles];
float[] targetRotations = new float[numPoles];

void resetTargetPoleRotationsTo(float targetRotation) {
  for(int i = 0; i < poleRotations.length; i++){
    targetRotations[i] = targetRotation;
  }
}

void setup() {
  size(600, 600, P3D);
  //spiral_column=loadShape("spiral_tube.obj");
  img = loadImage("spiral_bar.gif");
  float angle = 360.0 / tubeRes;
  for (int i = 0; i < tubeRes; i++) {
    tubeX[i] = cos(radians(i * angle));
    tubeY[i] = sin(radians(i * angle));
  }
  
   for(int i = 0; i < poleRotations.length; i++){
    poleRotations[i] = 0;
  }
  resetTargetPoleRotationsTo(0);
}

void setTargetRotation(int pole, float gazeX, float gazeY) {
  float poleCenter = pole * scaledDiameter + scaledDiameter / 2;
  
  float targetRotation = map(gazeY, 0, h, -0.5, 0.5);
  
  float rotation = targetRotation + (gazeX - poleCenter) / (w / 2.); 
  
  rotation = constrain(rotation, -.5, .5);
  targetRotations[pole] = rotation;
}

void draw() {
  background(0);
  lights();
  noStroke();
  fill(255, 255, 255);
  
   for(int i = 0; i < numPoles; i++) {
     setTargetRotation(i, mouseX, mouseY);
   }
   
   for(int i = 0; i < numPoles; i++ ) {
     poleRotations[i] = poleRotations[i] + (targetRotations[i] - poleRotations[i]) / 5.;
     //poleRotations[i] = -0.5;  
   }
 
  for(int i = 0; i < numPoles; i++) {
    drawPole(i);
  }
}


float cylinderDiameter = 1.25;
float cylinderCircumference = cylinderDiameter * PI;
float cylinderGap = 1./3;
float totalWidth = cylinderDiameter * 20 + cylinderGap * 21;
float scale = w / totalWidth;
float scaledDiameter = cylinderDiameter * scale;
float scaledRadius = cylinderDiameter / 2 * scale;
float scaledGap = cylinderGap * scale;

void drawPole(int pole) {
  float xOffset = scaledGap + scaledRadius + pole * (scaledDiameter + scaledGap);
  pushMatrix();
  //println(xOffset);
  //rotate(pole * 2, 90,);
  translate(xOffset, 0, 0);//translate(0, -40, 0);
  //shape(spiral_column, 0, 0);
  
  drawCylinder(poleRotations[pole], scaledRadius);
  //scale(1./50);
  //shape(spiral_column, 0, 0);
  popMatrix();
}

float angle = 360.0 / tubeRes;
void drawCylinder(float rotation, float topRadius) {
  //float angle = 0;
  //float angleIncrement = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  texture(img);
  for (int i = 0; i < tubeRes; i++) {
    float x = cos(radians(i * angle)) * topRadius;
    float z = sin(radians(i * angle)) * topRadius;
    float u = img.width * 1. / tubeRes * i;// + map(rotation, -1, 1, 0, 20);
    vertex(x, 0, z, u, h);
    vertex(x, h, z, u, 0);
  }
  endShape();
}