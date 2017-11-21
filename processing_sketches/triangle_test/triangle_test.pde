
void setup() {
  size(400, 400);
}

long start = millis();
void draw() {
  long elapsed = millis() - start;
  
  background(0);

  float percentage = mouseX / 400.;

  float rotation = map(percentage, 0, 1, -PI/2, PI/2);

  float triangleSize = 150;
  float tH = triangleSize * sqrt(3) / 2.; 

  translate(200, 200);
  rotate(rotation);
  triangle(-triangleSize/2, tH/2, triangleSize/2, tH/2, 0, -tH/2);
}