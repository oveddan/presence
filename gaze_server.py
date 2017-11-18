from gaze_detector_from_camera_stream import GazeDetectorStream
import json
import socket
from WebcamVideoStream import WebcamVideoStream
from gaze_detector import extract_features_and_detect_gazes

def to_output_string(outputs):
    output_string = None
    if (len(outputs) > 0):
        output_string = ""
        for i, output in enumerate(outputs):
            output_string += str(output[0]) + ',' + str(output[1])
            if (i < len(outputs) - 1):
                output_string += '_'
    return output_string

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 4006 # Arbitrary non-privileged port
vs = WebcamVideoStream(src=0).start()
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
try:
    print('Connected by', addr)
    while True:
        frame = vs.read()
        outputs = extract_features_and_detect_gazes(frame)
        #  outputs.append([0, 0])
        #  outputs.append([1, 1])
        output_string = to_output_string(outputs)

        if output_string is not None:
            conn.send((output_string + '\n').encode())
        #  if not data: break
            # do whatever you need to do with the data
            
finally:
    vs.stop()
    conn.close()
