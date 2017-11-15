import cv2
import numpy as np
from gaze_detector import extract_features_and_detect_gazes
from rendering import render_gazes_on_image


window_width = 1920
window_height = 1200
window_height_cm = 52
window_width_cm = 32.5
camera_h_from_screen_top = 3.75

cv2.namedWindow('image',cv2.WINDOW_NORMAL)
cv2.resizeWindow('image', window_width,window_height)

while(True):
    # Capture frame-by-frame
    if cv2.waitKey(33) == ord('p'):
        frame = cv2.imread('current.jpg')
        #set the width and height, and UNSUCCESSFULLY set the exposure time

        outputs = extract_features_and_detect_gazes(frame)

        resized = cv2.resize(frame,(window_width, window_height), interpolation = cv2.INTER_CUBIC)
        render_gazes_on_image(resized, outputs, window_width, window_height, window_width_cm, window_height_cm, camera_h_from_screen_top)
        # Our operations on the frame come here
        # Display the resulting frame
        cv2.imshow('image',resized)


    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    # When everything done, release the capture
cv2.destroyAllWindows()


#img = cv2.imread('notebooks/photos/IMG-1035.JPG')

#outputs = extract_features_and_detect_gazes(img)

#print(outputs)
