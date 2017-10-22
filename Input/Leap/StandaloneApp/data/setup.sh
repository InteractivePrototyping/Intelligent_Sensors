#!/bin/sh

echo "Downloading shape_predictor_68_face_landmarks.dat"
curl -L -o shape_predictor_68_face_landmarks.dat.bz2 --progress-bar https://sourceforge.net/projects/dclib/files/dlib/v18.10/shape_predictor_68_face_landmarks.dat.bz2

echo "Extracting shape_predictor_68_face_landmarks.dat"
bzip2 -d shape_predictor_68_face_landmarks.dat.bz2

echo "Downloading image-net-2012.sqlite3 and image-net-2012.words"
curl -L -o image-net-2012.sqlite3 --progress-bar https://raw.githubusercontent.com/liuliu/ccv/unstable/samples/image-net-2012.sqlite3
curl -L -o image-net-2012.words --progress-bar https://raw.githubusercontent.com/liuliu/ccv/unstable/samples/image-net-2012.words

echo "Downloading darknet weights"
curl -L -o darknet/darknet.weights --progress-bar http://pjreddie.com/media/files/darknet.weights
curl -L -o darknet/yolo9000.weights --progress-bar http://pjreddie.com/media/files/yolo9000.weights
curl -L -o darknet/go.weights --progress-bar http://pjreddie.com/media/files/go.weights

echo "Done"
