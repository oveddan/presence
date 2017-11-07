import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV faceOpenCv, eyeOpenCv;
color outline, contourcol;

int w = 800, h = 600;
int faceSize = 200;

void settings() {
  size(w,h);
}

void setup() {
  frameRate(60);
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

  // Only allow for 2 eyes in a face
  ArrayList<Rectangle> matchedEyes = new ArrayList<Rectangle>();

  // Filter results to return eyes inside the face
  for(int i = 0; i < eyes.length; i++) {
   if(
     (face.x + eyes[i].x) < (face.x + face.width) &&
     (eyes[i].y) < (face.height / 2)
   ) {
     // Check if biggest
     if(
       (matchedEyes.size() < 1) ||
       (eyes[i].width < matchedEyes.get(0).width &&
       eyes[i].height < matchedEyes.get(0).height)
     ) {
       // push second largest back
      if (matchedEyes.size() < 1) {
        matchedEyes.add(eyes[i]);
      } else {
        if(matchedEyes.size() < 2) {
          matchedEyes.add(eyes[i]);
        } else {
          matchedEyes.set(1,eyes[i]);
        }
        matchedEyes.set(0,eyes[i]);
      }
     }
     // Check if second biggest
     else if(
       (matchedEyes.size() < 2) ||
       (eyes[i].width < matchedEyes.get(1).width &&
       eyes[i].height < matchedEyes.get(1).height)
     ) {
      if(matchedEyes.size() < 2) {
        matchedEyes.add(eyes[i]);
      } else {
        matchedEyes.set(1,eyes[i]);
      }
     }
   }
  }

  Rectangle[] scaledEyes = new Rectangle[matchedEyes.size()];

  for(int i = 0; i < matchedEyes.size(); i++) {
    scaledEyes[i] = new Rectangle(round(matchedEyes.get(i).x * 1. / scaleFactor), round(matchedEyes.get(i).y * 1.  /scaleFactor), round(matchedEyes.get(i).width * 1. / scaleFactor), round(matchedEyes.get(i).height * 1. / scaleFactor));
  }

  return scaledEyes;
};

void drawFaceBox(Rectangle face) {
  noFill();
  stroke(outline);
  strokeWeight(2);
  Rectangle square = makeSquare(face);
  rect(square.x, square.y, square.width, square.height);
}

void drawEyeBox(Rectangle face, Rectangle eye) {
  noFill();
  stroke(0, 255, 0);
  strokeWeight(2);
  rect(face.x + eye.x, face.y + eye.y, eye.width, eye.height);
}

void drawGazePoint(Rectangle face, Rectangle[] eyes) {
  if(eyes.length == 2) {
    noStroke();
    fill(0, 0, 255);
    ellipseMode(CENTER);
    ellipse(face.x + (eyes[0].x + eyes[1].x) / 2, face.y + (eyes[0].y + eyes[1].y) / 2, 5, 5);
  }
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
  Rectangle[] faces = getFaces();
  image(video, 0, 0);
  for(int i = 0; i < faces.length; i++) {
      drawFaceBox(faces[i]);
      Rectangle[] eyes = getEyes(faces[i]);
    for(int j = 0; j < eyes.length; j++) {
      drawEyeBox(faces[i], eyes[j]);
    }
    drawGazePoint(faces[i], eyes);
  }
}

void captureEvent(Capture c) {
  c.read();
}
