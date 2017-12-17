int tubeRes = 32;
int numPoles = 21;
float[] tubeX = new float[tubeRes];
float[] tubeY = new float[tubeRes];

float gapSize = 4;

float tubeWidth = (w - (gapSize * (numPoles + 1))) / numPoles;
float tubeRadius = tubeWidth/2;

void setupPoles() {
  loadImages();
  float angle = 360.0 / (tubeRes-1);
  for (int i = 0; i < tubeRes; i++) {
    tubeX[i] = cos(radians(i * angle));
    tubeY[i] = sin(radians(i * angle));
  }
  noStroke();
}

float[] poleRotations = new float[numPoles];
float[] targetRotations = new float[numPoles];

void resetPoles() {
  
  for(int i = 0; i < poleRotations.length; i++){
    poleRotations[i] = 0;
    targetRotations[i] = 0;
  }
}

float getPoleCenterX(int pole) {
  return gapSize + tubeRadius + (tubeWidth + gapSize) * pole;
}

void setTargetRotation(int pole, float gazeX, float gazeY) {
  
  float poleCenter = getPoleCenterX(pole);
  
  float x = map(poleCenter - gazeX, float(-w), float(w), -PI, PI);
  
  float amplitude = map(gazeY, 0, h, 0, -1);
  
  boolean flip = amplitude < -.6;
  float rotation;
  if (flip)
    rotation = 1.5 - cos(1.5*x)/2 + amplitude;
  else
    rotation = .5 + cos(1.5*x)/2 + amplitude;
    
  rotation = constrain(rotation, 0, 1);
  
  targetRotations[pole] = rotation;
}


int design = 0;

String[] imagePaths = { 
  "spiral_bar_wider.gif", 
  "spiral_bar_wider.gif",
  "spiral_bar.gif",
  "white_bar.png",
  "white_spiral_white_sides.png",
  "white_spiral_inverted.png",
  "white_corners.png",
  "white_corners_with_boxes.png",
  "white_full_corners.png"
};


int numDesigns = imagePaths.length;

PImage[] images = new PImage[imagePaths.length];

PImage getImage() {
  return images[design];
}

void loadImages() {
  for(int i = 0; i < imagePaths.length; i++) {
    images[i] = loadImage(imagePaths[i]);
  }
}

void drawPole(int pole) {
  pushMatrix();
  translate(getPoleCenterX(pole), height / 2);
  rotateY(-PI);
  rotateY(map(poleRotations[pole], 0, 1, 0, -PI));
  beginShape(QUAD_STRIP);
  textureMode(NORMAL);
  texture(getImage());
  for (int i = 0; i < tubeRes; i++) {
    float x = tubeX[i] * tubeRadius;
    float z = tubeY[i] * tubeRadius;
    float u = 1 - 1. / (tubeRes-1)* i;
    vertex(x, -h/2, z, u, 0);
    vertex(x, h/2, z, u, 1);
  }
  endShape();
  popMatrix();
}

void updatePolesFromGazes(int[][] gazes) {
  int gazeX = gazes[0][0];
  int gazeY = gazes[0][1];
  for(int i = 0; i < numPoles; i++) {
    setTargetRotation(i, gazeX, gazeY);
  }
}

void animatePoles() {
  float animationSpeed = usingGaze && isActive() ? 50 : 20;
  for(int i = 0; i < numPoles; i++ ) {
    poleRotations[i] = poleRotations[i] + (targetRotations[i] - poleRotations[i]) / animationSpeed;
  }
}

void drawPoles() {
  background(0);
  lights();
  for(int i = 0; i < numPoles; i++) {
    drawPole(i);
  }
}

void changeDesign() {
  design++;
  if (design >= numDesigns) design = 0;
}