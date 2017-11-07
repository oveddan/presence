Build the docker image:

    docker build .

Run the container in bash:

    docker run -p 8080:8888 -i -t gaze_caffe /bin/bash

    docker run -v ~/Source/ITP/gaze/gaze_detector/gaze:/gaze -p 8080:8888 -i -t gaze_caffe /bin/bash

To start ipython notebook in the container:

    $ ipython notebook --ip 0.0.0.0

Open ipython notebook at `http://localhost:8080`
