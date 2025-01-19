#!/bin/bash
export APP_DEVICE=${APP_DEVICE:-1}


NBODY_PROBLEM_SIZE=256000
RSBENCH_PROBLEM_SIZE=large
ISING_PROBLEM_SIZE=1000
if [ $SMALL_PROBLEM = 1 ] ; then
  echo "Using small problem size"
  NBODY_PROBLEM_SIZE=64000
  RSBENCH_PROBLEM_SIZE=small
  ISING_PROBLEM_SIZE=100
fi


if [ $APP_DEVICE = 0 ] ; then
  APP_NAME=nbody bash run-hecbench-app.sh $NBODY_PROBLEM_SIZE 10
else
  APP_NAME=nbody bash run-hecbench-app.sh $NBODY_PROBLEM_SIZE 10
fi

APP_NAME=fft bash run-hecbench-app.sh 3 100
APP_NAME=rsbench bash run-hecbench-app.sh  -s $RSBENCH_PROBLEM_SIZE -m event
APP_NAME=mandelbrot bash run-hecbench-app.sh 1000
APP_NAME=ising bash run-hecbench-app.sh -x 5120 -y 5120 -w 10 -n $ISING_PROBLEM_SIZE
APP_NAME=dslash bash run-hecbench-app.sh 256
APP_NAME=fdtd3d bash run-hecbench-app.sh --dimx=376 --dimy=368 --timesteps=40
APP_NAME=sph bash run-hecbench-app.sh sph
