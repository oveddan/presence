import cv2
import numpy as np
from subprocess import call

cap = cv2.VideoCapture(1)

while(True):
    # Capture frame-by-frame
    #set the width and height, and UNSUCCESSFULLY set the exposure time
    cap.set(3,1280)
    cap.set(4,720)
    # birghtness
    cap.set(11, 0.1)
    cap.set(15, 0.01)
    ret, frame = cap.read()

    cv2.imwrite('current-new.jpg', frame)
    call(["mv", "current-new.jpg", "current.jpg"])

    # When everything done, release the capture
cv2.destroyAllWindows()


#img = cv2.imread('notebooks/photos/IMG-1035.JPG')

#outputs = extract_features_and_detect_gazes(img)

#
