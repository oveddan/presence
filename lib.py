import time

def current_time():
    return int(round(time.time() * 1000))

def crop_image(img, crop):
    return img[crop[1]:crop[1]+crop[3],crop[0]:crop[0]+crop[2],:] 
