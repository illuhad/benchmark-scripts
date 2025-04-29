#!/bin/bash

git clone https://github.com/illuhad/hecbench
cd hecbench
git checkout 6a853ad1
cd ..

APP_NAME=nbody sh ./build-hecbench-app.sh
APP_NAME=fft HIP_EXTRA_ARGS=-I../fft-cuda sh ./build-hecbench-app.sh
APP_NAME=rsbench sh ./build-hecbench-app.sh
APP_NAME=mandelbrot sh ./build-hecbench-app.sh
APP_NAME=ising sh ./build-hecbench-app.sh
APP_NAME=dslash sh ./build-hecbench-app.sh
APP_NAME=fdtd3d sh ./build-hecbench-app.sh
APP_NAME=sph sh ./build-hecbench-app.sh
