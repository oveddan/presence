# import the necessary packages
from threading import Thread
from WebcamVideoStream import WebcamVideoStream
from features import extract_image_features
import cv2

class FaceAndEyeDetectorStream:
    def __init__(self, src=0):
        # initialize the video camera stream and read the first frame
        # from the stream
        self.webcam_stream = WebcamVideoStream(src).start()

        frame, frame_time = self.webcam_stream.read()
        
        self.frame_time = frame_time
        (self.img, self.faces, self.face_features) = extract_image_features(frame)

        # initialize the variable used to indicate if the thread should
        # be stopped
        self.stopped = False

    def start(self):
        # start the thread to read frames from the video stream
        t = Thread(target=self.update, args=())
        t.daemon = True
        t.start()
        return self

    def update(self):
        # keep looping infinitely until the thread is stopped
        while True:
            # if the thread indicator variable is set, stop the thread
            #  print('updating')
            if self.stopped:
                #  print('returning')
                return

            # otherwise, read the next frame from the stream
            frame, frame_time = self.webcam_stream.read()
            self.frame_time = frame_time
            
            (self.img, self.faces, self.face_features) = extract_image_features(frame)
            #  print('the faces', self.faces)
            #  print('updated', self.grabbed)

    def read(self):
        # return the frame most recently read
        return (self.img, self.faces, self.face_features, self.frame_time)

    def stop(self):
        # indicate that the thread should be stopped
        self.webcam_stream.stop()
        self.stopped = True
