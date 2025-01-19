#!/bin/bash

rm -rf ./minibude

ACPP_ROOT_DIR=`acpp --acpp-version | grep 'Installation root: ' | awk '{sub(/^  Installation root: /, ""); print}'`
echo "Root dir: ${ACPP_ROOT_DIR}"

git clone https://github.com/uob-hpc/minibude
cd minibude
git checkout 570f66c
mkdir build-acpp && cd build-acpp
cmake -DMODEL=sycl -DSYCL_COMPILER=HIPSYCL -DHIPSYCL_TARGETS=generic -DSYCL_COMPILER_DIR=$ACPP_ROOT_DIR -DCXX_EXTRA_FLAGS="-ffast-math" ..
make
cd ..

if command -v nvcc 2>&1 >/dev/null
then
  mkdir build-cuda && cd build-cuda
  cmake -DMODEL=cuda -DCMAKE_CXX_COMPILER=`which nvcc` -DCMAKE_CUDA_COMPILER=`which nvcc` -DCUDA_ARCH="$CUDA_ARCH" -DENABLE_MPI=OFF  -DCUDA_EXTRA_FLAGS="--use_fast_math" ..
  make -j4
  cd ..
fi


if command -v hipcc 2>&1 >/dev/null
then
  mkdir build-hip && cd build-hip
  cmake -DMODEL=hip -DCMAKE_CXX_COMPILER=`which hipcc` -DENABLE_MPI=OFF  -DCXX_EXTRA_FLAGS="--offload-arch=$HIP_ARCH -ffast-math -fno-hip-fp32-correctly-rounded-divide-sqrt" ..
  make -j4
  cd ..
fi

if command -v icpx 2>&1 >/dev/null
then
  mkdir build-icpx && cd build-icpx
  cmake -DMODEL=sycl -DENABLE_MPI=OFF -DSYCL_COMPILER=ONEAPI-ICPX -DCXX_EXTRA_FLAGS="-ffast-math" ..
  make -j4
  cd ..
fi
