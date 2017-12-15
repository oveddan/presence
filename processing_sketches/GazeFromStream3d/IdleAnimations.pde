void topBottomAlternation(int pole) {
  int alternation = round(millis() / 5000.) % 2;
  targetRotations[pole] = alternation - pole % 2;
}

void rollingWave(int pole, long time) {
  float fract = (time - start) % 10000 / 10000.;
  float waveHeight = sin(((getPoleCenterX(pole)/w - fract) * 4));
  if(pole > 18)
  //println("wave", fract, pole,getPoleCenterX(pole), fract * w,  waveHeight);
  targetRotations[pole] = map(waveHeight, -1, 1, 0, 1);
}

void updateIdleAnimation() {
  long time = millis();
  for(int i = 0; i < numPoles; i++) {
    if (idleMode == 0)
      topBottomAlternation(i);
    else
      rollingWave(i, time);
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