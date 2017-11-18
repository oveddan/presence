# import the necessary packages
from WebcamVideoStream import WebcamVideoStream
from FPS import FPS
import imutils
import cv2

# created a *threaded* video stream, allow the camera sensor to warmup,
# and start the FPS counter
print("[INFO] sampling THREADED frames from webcam...")
vs = WebcamVideoStream(src=0).start()
fps = FPS().start()

# loop over some frames...this time using the threaded stream
while fps._numFrames < 1000:
    # grab the frame from the threaded video stream and resize it
    # to have a maximum width of 400 pixels
    frame = vs.read()

    # check to see if the frame should be displayed to our screen
    cv2.imshow("Frame", frame)

    # update the FPS counter
    fps.update()
    print(fps._numFrames)

# stop the timer and display FPS information
fps.stop()
print("[INFO] elasped time: {:.2f}".format(fps.elapsed()))
print("[INFO] approx. FPS: {:.2f}".format(fps.fps()))

# do a bit of cleanup
cv2.destroyAllWindows()
vs.stop()
