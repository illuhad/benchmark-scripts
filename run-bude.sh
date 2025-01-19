#!/bin/bash

APP_DEVICE=${APP_DEVICE:-1}
ICPX_APP_DEVICE=${ICPX_APP_DEVICE:-0}

root_dir=`pwd`
results_dir=$root_dir/results-bude-${RESULT_SUFFIX}
work_dir=$root_dir/minibude/build-acpp
mkdir -p $results_dir

cd $work_dir
sh $root_dir/run-benchmark.sh ./sycl-bude -w 128 -p 1,2,4 --device ${APP_DEVICE}
rm -rf $results_dir/*
mv out_al_* $results_dir/
mv errfile.txt $results_dir/

if [[ $ACPP_VISIBILITY_MASK = *cuda* ]]
then
  cd $work_dir/../build-cuda
  ./cuda-bude -w 128 -p 1,2,4 > out_native.txt
  mv out_native.txt $results_dir/
fi
if [[ $ACPP_VISIBILITY_MASK = *hip* ]]
then
  cd $work_dir/../build-hip
  ./hip-bude -w 128 -p 1,2,4 > out_native.txt
  mv out_native.txt $results_dir/
fi
if [[ $ACPP_VISIBILITY_MASK = *ocl* ]]
then
  cd $work_dir/../build-icpx
  ./sycl-bude -w 128 -p 1,2,4 --device ${ICPX_APP_DEVICE} > out_native.txt
  mv out_native.txt $results_dir/
fi
