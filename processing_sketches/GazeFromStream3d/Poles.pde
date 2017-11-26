int tubeRes = 32;
int numPoles = 24;
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

void setTargetRotation(int pole, float gazeX, float gazeY, boolean isActive) {
  if (!isActive) {
    int alternation = round(millis() / 5000.) % 2;
    targetRotations[pole] = alternation - pole % 2;
    return;
  }
    
  float poleCenter = getPoleCenterX(pole);
  
  float x = map(poleCenter - gazeX, float(-w), float(w), -PI, PI);
  
  float amplitude = map(gazeY, 0, h, 0, -1);
  
  
  
  //println(amplitude);
  //float heightAtPole = cos(x) + amplitude;
  
  //float rotation = constrain(map(heightAtPole, -1, 1, 0, PI), 0, PI);
  boolean flip = amplitude < -.6;
  float rotation;
  if (flip)
    rotation = 1.5 - cos(1.5*x)/2 + amplitude;
  else
    rotation = .5 + cos(1.5*x)/2 + amplitude;
    
  rotation = constrain(rotation, 0, 1);
  
  targetRotations[pole] = rotation;
}
PImage img0;
PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage img5;
PImage img6;
PImage img7;

void loadImages() {
  img0 = loadImage("spiral_bar_wider.gif");
  img1 = loadImage("spiral_bar.gif");
  img2 = loadImage("white_bar.png");
  img3 = loadImage("white_spiral_white_sides.png");
  img4 = loadImage("white_spiral_inverted.png");
  img5 = loadImage("white_corners.png");
  img6 = loadImage("white_corners_with_boxes.png");
  img7 = loadImage("white_full_corners.png");
}

PImage getImage() {
  switch(design) {
    case 0:
      return img0;
    case 1:
      return img1;
    case 2:
      return img2;
    case 3:
      return img3;
    case 4:
      return img4;
    case 5:
      return img5;
    case 6:
      return img6;
    case 7:
      return img7;
    default:
     return img0;
  }
}

void drawPole(int pole) {
  pushMatrix();
  translate(getPoleCenterX(pole), height / 2);
  //rotateX(map(mouseY, 0, height, -PI, PI));
  rotateY(-PI);
  //println(pole, poleRotations[pole], map(poleRotations[pole], 0, 1, 0, -PI));
  rotateY(map(poleRotations[pole], 0, 1, 0, -PI));
//  rotateY(poleRotations[pole]);
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

void updatePoles(int[][] gazes) {
  int gazeX = gazes[0][0];
  int gazeY = gazes[0][1];
  boolean isActive = (millis() - lastMouseMovedTime) / 1000. < 5.;
  for(int i = 0; i < numPoles; i++) {
    setTargetRotation(i, gazeX, gazeY, isActive);
  }
   
  for(int i = 0; i < numPoles; i++ ) {
    poleRotations[i] = poleRotations[i] + (targetRotations[i] - poleRotations[i]) / 10.;
   //poleRotations[i] = -0.5; 
   //poleRotations[i] = targetRotations[i];
   
   //print(i, ":", poleRotations[i], ",");
  }
  //println();
}

void drawPoles() {
  background(0);
  lights();
  for(int i = 0; i < numPoles; i++) {
    drawPole(i);
  }
}