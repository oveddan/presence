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

void updateIdleAnimation() {
  long time = millis();
  for(int i = 0; i < numPoles; i++) {
    if (idleMode == 0)
      topBottomAlternation(i);
    else {
      rollingWave(i, time);
    }
  }
}
    
long start = millis();
int idleMode = 1;
int numIdleModes = 2;
void changeIdleMode() {
  idleMode++;
  if (idleMode >= numIdleModes) idleMode = 0;
  start = millis();
}