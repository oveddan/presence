import cv2
import numpy as np
import warnings
warnings.filterwarnings("ignore")

from gaze_detector import extract_features_and_detect_gazes

window_width = 1920
window_height = 1200
width = 1280
height = 720


def get_next_unbuffered_frame(cap):
    for i in range(0, 0):
        ret, last_frame = cap.read()
        print(i)
        if ret == False:
            break

    return ret, last_frame

class GazeDetectorStream:
    def __init__(self):
        cap = cv2.VideoCapture(0)
        cap.set(3,1280)
        cap.set(4,720)
        # birghtness
        cap.set(11, 0.1)
        cap.set(15, 0.01)
        # set fps to 10
        cap.set(cv2.CAP_PROP_FRAME_COUNT, 1)
        cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)

        cap.set(6, 1)
        self.is_first_frame = True
        self.cap = cap

    def __iter__(self):
        return self

    def __next__(self):
        if self.is_first_frame:
            ret, frame = self.cap.read()
            self.is_first_frame = False
        else:
            frame = get_next_unbuffered_frame(self.cap)

        outputs = extract_features_and_detect_gazes(frame)

        return frame, outputs
