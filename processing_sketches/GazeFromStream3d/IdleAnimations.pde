void topBottomAlternation() {
  long time = millis();
  for (int pole = 0; pole < numPoles; pole++) {
    int alternation = round(time / 5000.) % 2;
    targetRotations[pole] = alternation - pole % 2;
  }
}

void rollingWave() {
  long time = millis();
  for (int pole = 0; pole < numPoles; pole++) {
    float fract = (time - start) % 10000 / 10000.;
    float timeInAnim = fract * PI;
    float waveHeight = sin(((getPoleCenterX(pole)/w - timeInAnim) * 2));
    //if(pole > 18)
    //println("wave", fract, pole,getPoleCenterX(pole), fract * w,  waveHeight);
    targetRotations[pole] = constrain(map(waveHeight, -1, 1, 0, 1), 0, 1);
  }
}

float x1 = 0;
float y1 = 0;
float changeAmount = 0.001;
float deltaX = changeAmount;
float deltaY = 0;
void rotatingX() {  
  float theta = millis() / 10000.;
  float centerX = w/2;
  
  for(int pole = 0; pole < numPoles; pole++) {
    float poleDistanceFromCenter = centerX - getPoleCenterX(pole);
    
    float yAtPole = poleDistanceFromCenter * tan(theta);
    
    float rotation = constrain(map(yAtPole, -h, h, 0, 1), 0, 1);
    
    if(pole == 20)
      println(pole, theta, yAtPole);

    poleRotations[pole] = rotation;
  }
}

long start = millis();

void updateIdleAnimation() {
  long time = millis();
  if (idleMode == 0)
    topBottomAlternation();
  else if(idleMode == 1) {
    rollingWave();
  } else if (idleMode == 2) {
    rotatingX();
  }
  
  if (millis() - start > 60000)
    changeIdleMode();
}
int idleMode = 2;
int numIdleModes = 3;
void changeIdleMode() {
  idleMode++;
  if (idleMode >= numIdleModes) idleMode = 0;
  start = millis();
}