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
  myClient = new Client(this, "127.0.0.1", 4005); 
  for(int i = 0; i < 10; i++) {
    targetGazes[i][0] = 0;
    targetGazes[i][1] = 0;
    currentGazes[i][0] = 0;
    currentGazes[i][1] = 0;
  }
} 

void parseAndSetGazes(String gazeString) {
    if(gazeString.contains("_")){ 
        String[] outputStrings = gazeString.split("_");
        //print("output string", outputStrings[0]);
        numGazes = outputStrings.length;
        for(int i = 0; i < outputStrings.length; i++) {
          //println("output strings :", outputStrings[i]);
          String[] parts = outputStrings[i].split(",");
          
        //print("parts", parts[0], parts[1]);
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

float maxWidthCm = 10;
float maxHeightCm = 5;
void drawGazes() {
  for(int i = 0; i < numGazes; i++) {
    float x = map(currentGazes[i][0], -maxWidthCm, maxWidthCm, 0, w);
    float y = map(currentGazes[i][1], -2.5, -20, 0, h);

//    println("x and y", x, y);
    
    fill(255, 0, 0);
    ellipse(round(x), round(y), 20, 20);
    textSize(26);
    text(currentGazes[i][0] + "," + currentGazes[i][1] + "cm", round(x) -100, round(y) + 40);
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
} 