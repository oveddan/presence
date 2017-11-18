import processing.net.*; 

Client myClient; 

int w = 1920;
int h = 1080;

void settings() {
  size(w, h);
}
 
 
float[][] targetGazes = new float[10][2];
float[][] currentGazes = new float[10][2];



int numGazes = 0;
void setup() { 
  size(800, 800); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "127.0.0.1", 4006); 
  for(int i = 0; i < 10; i++) {
    targetGazes[i][0] = 0;
    targetGazes[i][1] = 0;
    currentGazes[i][0] = 0;
    currentGazes[i][1] = 0;
  }
  
  resetPoles();
} 

void parseAndSetGazes(String gazeString) {
    if(gazeString.contains("_")){ 
        String[] outputStrings = gazeString.split("_");
        //print("output string", outputStrings[0]);
        numGazes = outputStrings.length;
        for(int i = 0; i < outputStrings.length; i++) {
          String[] parts = outputStrings[i].split(",");
          
          targetGazes[i][0] = float(parts[0]);
          targetGazes[i][1] = float(parts[1]);
        }
     }
     else {
        numGazes = 1;
        String[] parts = gazeString.split(",");
        targetGazes[0][0] = float(parts[0]);
        targetGazes[0][1] = float(parts[1]);
      }
      
      
  println("Parsed");
}

float animationSpeed = 20.;
void moveGazesToTargets() {
  for (int i = 0; i < numGazes; i++) {
    print("Grouped", currentGazes[i][0], targetGazes[i][0]);
    currentGazes[i][0] =currentGazes[i][0] += (targetGazes[i][0] - currentGazes[i][0]) / animationSpeed;
    currentGazes[i][1] =currentGazes[i][1] += (targetGazes[i][1] - currentGazes[i][1]) / animationSpeed;
  }  
}

int mapGazeX(float gazeX) {
  return round(map(gazeX, -maxWidthCm, maxWidthCm, 0, w));
}

int mapGazeY(float gazeY) {
  return round(map(gazeY, -2.5, -20, 0, h));
}

float maxWidthCm = 10;
float maxHeightCm = 5;
void drawGazes() {
  for(int i = 0; i < numGazes; i++) {
    int x = mapGazeX(currentGazes[i][0]);
    int y = mapGazeY(currentGazes[i][1]);

    fill(255, 0, 0);
    ellipse(x, y, 20, 20);
    textSize(26);
    //text(currentGazes[i][0] + "," + currentGazes[i][1] + "cm", round(x) -100, round(y) + 40);
  }
}
 
 
void draw() { 
  if (myClient.available() > 0) { 
    String gazeString = myClient.readStringUntil('\n');
    
    if (gazeString != null) {
      parseAndSetGazes(gazeString.replaceAll("\n", ""));
    }
  } 
  
  background(255);
  moveGazesToTargets();
  
  drawGazes();
  
  if (numGazes > 0) {
    int x = mapGazeX(currentGazes[0][0]);
    int y = mapGazeY(currentGazes[0][1]);
    updatePoles(x, y);
  }
  drawPoles();
} 