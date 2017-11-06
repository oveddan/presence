import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV faceOpenCv;
OpenCV eyeOpenCv;

int bounds;
color outline;
color contourcol;
float detail;
int threshval;

int w = 800;
int h = 600;
void settings() {
  size(w,h);
  
}


int faceSize = 200;

void setup() {
  frameRate(30);
  bounds=20;
  detail=1.5;
  threshval=40;
  outline=color (255,255,255);
  contourcol=color (229,234,251);
  faceOpenCv = new OpenCV(this, w/2, h/2);
  faceOpenCv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  eyeOpenCv = new OpenCV(this,faceSize,faceSize);
  eyeOpenCv.loadCascade(OpenCV.CASCADE_EYE);
  println("staring video");
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    video = new Capture(this, w/2, h/2);
    video.start();     
  }  
}

Rectangle[] getFaces(){
  faceOpenCv.loadImage(video);
  return faceOpenCv.detect();
}

Rectangle makeSquare(Rectangle rectangle) {
  int size = max(rectangle.width, rectangle.height);
  
  return new Rectangle(rectangle.x, rectangle.y, size, size);
}

Rectangle[] getEyes(Rectangle face) {
  Rectangle square = makeSquare(face);
  PImage faceImage = video.get(square.x, square.y, square.width, square.height);
  faceImage.resize(faceSize, faceSize);
  float scaleFactor = faceSize / square.width;
  eyeOpenCv.loadImage(faceImage);
  Rectangle[] eyes = eyeOpenCv.detect();
  
  Rectangle[] scaledEyes = new Rectangle[eyes.length];
  
  println(scaleFactor);
  for(int i = 0; i < eyes.length; i++) {
    scaledEyes[i] = new Rectangle(round(eyes[i].x * 1. / scaleFactor), round(eyes[i].y * 1.  /scaleFactor), round(eyes[i].width * 1. / scaleFactor), round(eyes[i].height * 1. / scaleFactor));
  }
  return scaledEyes;
};

void drawFaceBox(Rectangle face){
  noFill();
  stroke(outline);
  strokeWeight(2);
  Rectangle square = makeSquare(face);
  //println(square);
  rect(square.x, square.y, square.width, square.height);
}

void drawEyeBox(Rectangle face, Rectangle eye) {
  noFill();
  stroke(0, 255, 0);
  strokeWeight(2);
  rect(face.x + eye.x, face.y + eye.y, eye.width, eye.height);
}

void setVars(){
  threshval=int(map(mouseX,0,width,0,255));
  print("Threshval:"+threshval);
  print("--");
  detail=map(mouseY,0,height,0,10);
  print("Detail:"+detail);
  print("-----");
}

void drawFace(Rectangle face) {
  println(face);
  PImage faceImage = video.get(face.x, face.y, face.width, face.height);
  image(faceImage, 0, 0, w/2, h/2);
}

void draw() {
  noStroke();
  fill(32,37,59,90);
  rect(0,0,width,height);
  scale(2);
  //println("drawing");
  Rectangle[] faces = getFaces();
  image(video, 0, 0);
  for(int i = 0; i < faces.length; i++) {
      drawFaceBox(faces[i]);
      Rectangle[] eyes = getEyes(faces[i]);
      
    println(eyes.length);
    for(int j = 0; j < eyes.length; j++) {
      drawEyeBox(faces[i], eyes[j]);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}