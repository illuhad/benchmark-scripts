#!/bin/bash

rm -rf ./cloverleaf

ACPP_ROOT_DIR=`acpp --acpp-version | grep 'Installation root: ' | awk '{sub(/^  Installation root: /, ""); print}'`
echo "Root dir: ${ACPP_ROOT_DIR}"

git clone https://github.com/uob-hpc/cloverleaf
cd cloverleaf
git checkout 3e10ff9

mkdir build-acpp && cd build-acpp

# NOTE: cloverleaf cmake defaults to -DCMAKE_BUILD_TYPE=Release, so specifying it is not necessary to get a release build!
cmake -DMODEL=sycl-acc -DENABLE_MPI=OFF -DSYCL_COMPILER=HIPSYCL -DHIPSYCL_TARGETS=generic -DSYCL_COMPILER_DIR=$ACPP_ROOT_DIR -DCXX_EXTRA_FLAGS="-ffast-math" ..
make -j4
cd ..

if command -v nvcc 2>&1 >/dev/null
then
  mkdir build-cuda && cd build-cuda
  cmake -DMODEL=cuda -DCMAKE_CUDA_COMPILER=`which nvcc` -DCUDA_ARCH="$CUDA_ARCH" -DENABLE_MPI=OFF  -DCXX_EXTRA_FLAGS="--use_fast_math" ..
  make -j4
  cd ..
fi

if command -v hipcc 2>&1 >/dev/null
then
  mkdir build-hip && cd build-hip
  cmake -DMODEL=hip -DCMAKE_CXX_COMPILER=`which hipcc` -DENABLE_MPI=OFF  -DCXX_EXTRA_FLAGS="-DgcnArch=gcnArchName --offload-arch=$HIP_ARCH -ffast-math -fno-hip-fp32-correctly-rounded-divide-sqrt" ..
  make -j4
  cd ..
fi

if command -v icpx 2>&1 >/dev/null
then
  mkdir build-icpx && cd build-icpx
  cmake -DMODEL=sycl-acc -DENABLE_MPI=OFF -DSYCL_COMPILER=ONEAPI-ICPX -DCXX_EXTRA_FLAGS="-ffast-math" ..
  make -j4
  cd ..
fi
