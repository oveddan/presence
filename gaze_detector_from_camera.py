import cv2
import numpy as np
import warnings
warnings.filterwarnings("ignore")

from gaze_detector import extract_features_and_detect_gazes
from rendering import render_gazes_on_image, render_gaze_on_simulated_screen, combine_simulated_and_screen


window_width = 1920
window_height = 1200
window_height_cm = 28.5
window_width_cm = 32.5
camera_h_from_screen_top = 12

cv2.namedWindow('image',cv2.WINDOW_NORMAL)
cv2.resizeWindow('image', window_width,window_height)


cap = cv2.VideoCapture(0)
fourcc = cv2.VideoWriter_fourcc(*'XVID')
output_video_height = 480
t = cv2.VideoWriter('outputs/output.avi',fourcc, 20.0, (640,output_video_height))
width = 1280
height = 720
cap.set(3,1280)
cap.set(4,720)
# birghtness
cap.set(11, 0.1)
cap.set(15, 0.01)
# set fps to 10
cap.set(6, 1)

def get_frame_number(frame):
    if frame < 10:
        return "0" + str(frame)
    else:
        return str(frame)

frame_number = 0
while(True):
    total_frames = cap.get(7)
    print(total_frames)
    ret, frame = cap.read()
    # Capture frame-by-frame
    #  frame = cv2.imread('current.jpg')
    #set the width and height, and UNSUCCESSFULLY set the exposure time

    outputs = extract_features_and_detect_gazes(frame)

    #  resized = cv2.resize(frame,(window_width, window_height), interpolation = cv2.INTER_CUBIC)
    #  flipped = cv2.flip(resized, 1)

    #render_gazes_on_image(flipped, outputs, window_width, window_height, window_height_cm, camera_h_from_screen_top)

    #results_and_screen = combine_simulated_and_screen(300, width, height, outputs, frame)
    simulated_screen = render_gaze_on_simulated_screen(800, outputs)

    gray = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY )

    #  cv2.imshow('image', gray)
    #  cv2.imshow('image', simulated_screen)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    #  if frame_number  < 100:
        #  shrunk = cv2.resize(flipped,None,fx=0.25,fy=0.25, interpolation = cv2.INTER_CUBIC)
        #  cv2.imwrite("output/" + get_frame_number(frame_number) + ".jpg",shrunk)

    frame_number += 1

    # When everything done, release the capture
cv2.destroyAllWindows()


#img = cv2.imread('notebooks/photos/IMG-1035.JPG')

#outputs = extract_features_and_detect_gazes(img)

#print(outputs)
