#!/bin/bash

cd hecbench
root_dir=`pwd`/src

cd $root_dir/$APP_NAME-sycl
acpp -O3 -ffast-math -o sycl-generic-cpu $SYCL_EXTRA_ARGS *.cpp
acpp -O3 -ffast-math -o sycl-generic $SYCL_EXTRA_ARGS *.cpp -DUSE_GPU
cd $root_dir


if command -v nvcc 2>&1 >/dev/null
then
  cd $root_dir/$APP_NAME-cuda
  nvcc -O3 --use_fast_math -arch=$CUDA_ARCH -o cuda $CUDA_EXTRA_ARGS `find . -maxdepth 1 -name '*.cpp' -or -name '*.cu'`
  cd $root_dir
fi

if command -v hipcc 2>&1 >/dev/null
then
  cd $root_dir/$APP_NAME-hip
  hipcc -O3 -ffast-math --offload-arch=$HIP_ARCH -fno-hip-fp32-correctly-rounded-divide-sqrt -o hip $HIP_EXTRA_ARGS `find . -maxdepth 1 -name '*.cpp' -or -name '*.cu'`
  cd $root_dir
fi

if command -v icpx 2>&1 >/dev/null
then
  cd $root_dir/$APP_NAME-sycl
  icpx -fsycl -O3 -ffast-math -o icpx-cpu $SYCL_EXTRA_ARGS *.cpp
  icpx -fsycl -O3 -ffast-math -o icpx $SYCL_EXTRA_ARGS *.cpp -DUSE_GPU
  cd $root_dir
fi
