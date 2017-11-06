int w = 800;
int h = 300;

void settings() {
  size(w, h);
}

int numPoles = 20;
float poleWidth = w * 1.0 / numPoles;
float fullPoleSize = poleWidth * 2;

float[] poleRotations = new float[numPoles];

void setup() {
  for(int i = 0; i < poleRotations.length; i++){
    poleRotations[i] = 0;
  }
}

float getTargetRotation(float gaze, boolean notGazing, int pole) {
  if (notGazing) return -1;
  float poleCenter = pole * poleWidth + poleWidth / 2;
  //if(pole == 10) {
  //  print(gaze);
  //  print(' ');
  //  print(poleCenter);
  //  print(' ');
  //println((gaze - poleCenter) / (w / 2.));
  //}
  float rotation = (gaze - poleCenter) / (w / 4.); 
  
  return -constrain(rotation, -1., 1.);
} 

long start = millis();
PGraphics pg;

void drawPole(int pole, long time) {
  pg = createGraphics(floor(poleWidth), h);
  pg.beginDraw();
  pg.fill(0);
  pg.translate(poleRotations[pole] * poleWidth, 0);
  pg.rect(-poleWidth, h * noise(pole - 1), poleWidth, 10.); 
  pg.rect(-poleWidth, h * noise(pole), poleWidth, 10.); 
  pg.rect(-poleWidth, h * noise(pole - 2), poleWidth, 10.); 
  pg.rect(poleWidth, h * noise(pole + 1), poleWidth, 10.);
  pg.rect(poleWidth, h * noise(pole + 2), poleWidth, 10.);
  pg.rect(poleWidth, h * noise(pole + 3), poleWidth, 10.);
  pg.endDraw();
  
  pushMatrix();
  translate(pole * poleWidth, 0);
  image(pg, 0, 0, poleWidth, h);
  strokeWeight(10);
  stroke(255);
  line(poleWidth, 0, poleWidth, h);
  popMatrix();
}

void draw() {
   background(255);
   
   long time = millis() - start;
   
   float gazeDirection = mouseX;
   boolean notGazing =  (mouseY > h - 20 || mouseY < 20);
   
   for(int i = 0; i < numPoles; i++ ) {
     float targetRotation = getTargetRotation(gazeDirection, notGazing, i);
     
     poleRotations[i] = poleRotations[i] + (targetRotation - poleRotations[i]) / 100.;
   }
 
   
   for(int i = 0; i < numPoles; i++) {
     drawPole(i, time);
   }
}