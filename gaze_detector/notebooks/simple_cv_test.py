import time
from SimpleCV import Camera

cam = Camera()
time.sleep(0.1)  # If you don't wait, the image will be dark
img = cam.getImage()
