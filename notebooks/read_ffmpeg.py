import numpy
import subprocess as sp
import cv2

FFMPEG_BIN = "ffmpeg" # on Linux ans Mac OS

command = [ FFMPEG_BIN,
            '-y',
            '-i', '/dev/video1',
            '-f', 'image2pipe',
            #  '-pix_fmt', 'rgb24',
            '-vcodec', 'rawvideo', '-']
pipe = sp.Popen(command, stdout = sp.PIPE, bufsize=10**8)

print('reading raw image')
raw_image = pipe.stdout.read(640*480*3)
# transform the byte read into a numpy array
print('converting')
image =  numpy.fromstring(raw_image, dtype='uint8')
print(image.shape)
image = image.reshape((640,480,3))


cv2.imwrite('image.png',image)
# throw away the data in the pipe's buffer.
pipe.stdout.flush()
