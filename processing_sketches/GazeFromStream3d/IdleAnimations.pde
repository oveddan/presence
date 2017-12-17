void topBottomAlternation(int pole) {
  int alternation = round(millis() / 5000.) % 2;
  targetRotations[pole] = alternation - pole % 2;
}

void rollingWave(int pole, long time) {
  float fract = (time - start) % 10000 / 10000.;
  float timeInAnim = fract * PI;
  float waveHeight = sin(((getPoleCenterX(pole)/w - timeInAnim) * 2));
  //if(pole > 18)
  //println("wave", fract, pole,getPoleCenterX(pole), fract * w,  waveHeight);
  targetRotations[pole] = constrain(map(waveHeight, -1, 1, 0, 1), 0, 1);
}

float lineTop = 0;
void rotatingX(int pole, long time) {
  float fract = (time - start) % 10000 / 10000.;
  float y1 = h;
  float y2 = 0;
  float x1 = fract * w;
  float x2 = (1-fract)*w;
  float slope = (y2 - y1) / (x2 - x1);
  float x = getPoleCenterX(pole);
  float y = slope * x;
  float yPercentage = y / h;
  
  targetRotations[pole] = 1 - yPercentage;
}

long start = millis();

void updateIdleAnimation() {
  long time = millis();
  for(int i = 0; i < numPoles; i++) {
    if (idleMode == 0)
      topBottomAlternation(i);
    else if(idleMode == 1) {
      rollingWave(i, time);
    } else if (idleMode == 2) {
      rotatingX(i, time);
    }
  }
  
  if (millis() - start > 60000)
    changeIdleMode();
}
int idleMode = 0;
int numIdleModes = 2;
void changeIdleMode() {
  idleMode++;
  if (idleMode >= numIdleModes) idleMode = 0;
  start = millis();
}