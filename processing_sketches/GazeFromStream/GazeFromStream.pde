import processing.net.*; 

Client myClient; 

int w = 1000;
int h = 1000;

void settings() {
  size(w, h);
}
 
void setup() { 
  size(800, 800); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "127.0.0.1", 4002); 
} 
 
float[][] gazes = new float[0][2];

void parseAndSetGazes(String gazeString) {
    if(gazeString.contains("|")){ 
        String[] outputStrings = gazeString.split("|");
        gazes = new float[outputStrings.length][2];
        for(int i = 0; i < outputStrings.length; i++) {
          String[] parts = outputStrings[i].split(",");
          gazes[i][0] = float(parts[0]);
          gazes[i][1] = float(parts[1]);
        }
     }
     else {
        gazes = new float[1][2];
        println(gazeString, gazeString.split(",").length);
        String[] parts = gazeString.split(",");
        gazes[0][0] = float(parts[0]);
        gazes[0][1] = float(parts[1]);
      }
      
      
  println("Parsed");
}

float maxWidthCm = 15;
float maxHeightCm = 5;
void drawGazes() {
  println("drawing gazes: ", gazes.length);
  for(int i = 0; i < gazes.length; i++) {
    float x = map(gazes[i][0], -maxWidthCm, maxWidthCm, 0, w);
    float y = map(gazes[i][1], -maxHeightCm, -3.5, h, 0);
    
    println("x and y", x, y);
    
    fill(255, 0, 0);
    ellipse(round(x), round(y), 20, 20);
  }
}
 
void draw() { 
  if (myClient.available() > 0) { 
    String gazeString = myClient.readStringUntil('\n');
    
    if (gazeString != null) {
      print(gazeString);
      parseAndSetGazes(gazeString.replaceAll("\n", ""));
    }
  } 
  
  background(255);
  drawGazes();
} 