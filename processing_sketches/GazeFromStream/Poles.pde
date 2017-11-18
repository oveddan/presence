

int numPoles = 24;
float poleWidth = w * 1.0 / numPoles;
float fullPoleSize = poleWidth * 2;

float[] poleRotations = new float[numPoles];
float[] targetRotations = new float[numPoles];

void resetPoles() {
  
  for(int i = 0; i < poleRotations.length; i++){
    poleRotations[i] = 0;
    targetRotations[i] = 0;
  }
}


void setTargetRotation(int pole, float gazeX, float gazeY) {
  float poleCenter = pole * poleWidth + poleWidth / 2;
  
  float distanceFromWave = map(gazeX - poleCenter, float(-w), float(w), -PI, PI);

  float amplitude = map(gazeY, h, 0, .5, -.5);
  
  float heightAtP = cos(distanceFromWave) * amplitude;
  
  float rotation = heightAtP; 
  
  targetRotations[pole] = rotation;
}

long start = millis();

PGraphics pg;
void drawPole(int pole, long time) {
  pg = createGraphics(floor(poleWidth), h);
  pg.beginDraw();
  pg.translate(poleRotations[pole] * poleWidth, 0);
  pg.stroke(0);
  pg.strokeWeight(5);
  pg.line(-poleWidth/2, h, poleWidth + poleWidth/2, 0);
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

void updatePoles(int gazeX, int gazeY) {
  for(int i = 0; i < numPoles; i++) {
     setTargetRotation(i, gazeX, gazeY);
   }
   
   for(int i = 0; i < numPoles; i++ ) {
     poleRotations[i] = poleRotations[i] + (targetRotations[i] - poleRotations[i]) / 10.;
   //poleRotations[i] = -0.5;  
 }
}

void drawPoles() {
  long time = millis() - start;
   
   for(int i = 0; i < numPoles; i++) {
     drawPole(i, time);
   }
   
   for(int i = 0; i < numPoles; i++) {
     drawDivider(i);
   }  
}