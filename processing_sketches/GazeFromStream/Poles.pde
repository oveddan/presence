

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

//long start = millis();


void setTargetRotation(int pole, float gazeX, float gazeY) {
  float poleCenter = pole * poleWidth + poleWidth / 2;
  
  float distanceFromWave = map(gazeX - poleCenter, float(-w), float(w), -PI, PI);

  float amplitude = map(gazeY, 0, h, 1, 0);
  
  float heightAtP = cos(distanceFromWave) * amplitude;
  
  
  //float wavePosition = (millis() - start) % 1000 / 1000.;
  //float poleRelativePosition = map(poleCenter, 0, w, 0, 1);
  //float distanceFromWavePosition = wavePosition - poleRelativePosition;
  
  float rotation = -(heightAtP - .5);
  //rotation += distanceFromWavePosition * 0.1;
  
  //if (heightAtP < 0.)
  //  heightAtP+=1;
  // else if (heightAtP > 1.){
  //   heightAtP -= 1;
  // }
  
  rotation = constrain(rotation, -.5, .5);
  
  targetRotations[pole] = rotation;
}

long start = millis();

void drawSpiral() {
    pg.stroke(0);
    pg.strokeWeight(10);
    pg.line(-poleWidth/2, h, poleWidth + poleWidth/2, 0);
}

void drawRevealingColumn() {
    pg.fill(0);
    pg.rect(-poleWidth/2, 0, poleWidth/2, h);
    pg.rect(poleWidth, 0, poleWidth/2, h);
}

color left = color(255, 0, 0);
color right = color(0, 0, 255);

void drawRevealingColumnGradient(int pole) {
    pg.fill(lerpColor(left, right, pole * 1. / numPoles));
    pg.rect(-poleWidth/2, 0, poleWidth/2, h);
    pg.rect(poleWidth, 0, poleWidth/2, h);
}

PGraphics pg;
void drawPole(int pole, long time) {
  pg = createGraphics(floor(poleWidth), h);
  pg.beginDraw();
  pg.translate(poleRotations[pole] * poleWidth, 0);
  if (design == 0) {
    drawSpiral();
  } else if (design == 1) {
    drawRevealingColumn();
  }else if (design == 2) {
    drawRevealingColumnGradient(pole);
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

void updatePoles(int[][] gazes) {
  int gazeX = gazes[0][0];
  int gazeY = gazes[0][1];
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