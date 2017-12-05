import processing.net.*; 

Client myClient; 

//int w = 1920;
//int h = 1080;
int w = 800;
int h = 800;

void settings() {
  size(w, h);
}
 
 
long lastUpdateTime = millis();
float[][] targetGazes = new float[10][2];
float[][] currentGazes = new float[10][2];



int numGazes = 0;
void setup() { 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "127.0.0.1", 4002); 
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
          
          if(parts.length == 2) {
            targetGazes[i][0] = float(parts[0]);
            targetGazes[i][1] = float(parts[1]);
          }
        }
     }
     else {
        numGazes = 1;
        String[] parts = gazeString.split(",");
        if(parts.length == 2) {
          targetGazes[0][0] = float(parts[0]);
          targetGazes[0][1] = float(parts[1]);
        }
      }
      
  lastUpdateTime = millis();
}


float animationSpeed = 5.;
void moveGazesToTargets() {
  for (int i = 0; i < numGazes; i++) {
    //print("Grouped", currentGazes[i][0], targetGazes[i][0]);
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
    //textSize(26);
    //text(currentGazes[i][0] + "," + currentGazes[i][1] + "cm", round(x) -100, round(y) + 40);
  }
}

boolean usingGaze = false;

int[][] getGazes() {
  int [][] gazes;
  
  if (usingGaze) {
    gazes = new int[numGazes][2];
    
    for (int i = 0; i < numGazes; i++) {
      gazes[i][0] = mapGazeX(currentGazes[i][0]);
      gazes[i][1] = mapGazeY(currentGazes[i][1]);
    }
  } else {
    gazes = new int[1][2];
    gazes[0][0] = mouseX;
    gazes[0][1] = mouseY;
  }
  return gazes;
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
  
  int[][] gazes = getGazes();
  
  if (design < 2) {
    if (gazes.length > 0)
      updatePoles(gazes);
      
    drawPoles();
  } else if (design == 2) {
    drawParticleSystem(gazes);
  }
} 

int design = 0;
int numDesigns = 4;
void keyPressed() {
  if(key == TAB) {
    design++;
    if (design >= numDesigns) design = 0;
  }
}
