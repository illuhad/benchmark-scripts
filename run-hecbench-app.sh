#!/bin/bash

APP_DEVICE=${APP_DEVICE:-1}

root_dir=`pwd`
results_dir=$root_dir/results-$APP_NAME-${RESULT_SUFFIX}
work_dir=$root_dir/hecbench/src/$APP_NAME-sycl

mkdir -p $results_dir

echo "Running $APP_NAME"

cd $work_dir
if [ $APP_DEVICE = 0 ] ; then
  sh $root_dir/run-benchmark.sh ./sycl-generic-cpu $@
else
  sh $root_dir/run-benchmark.sh ./sycl-generic $@
fi

rm -rf $results_dir/*
mv out_al_* $results_dir/
mv errfile.txt $results_dir/

if [[ $ACPP_VISIBILITY_MASK = *cuda* ]]
then
  cd $root_dir/hecbench/src/$APP_NAME-cuda
  ./cuda $@ > out_native.txt
  mv out_native.txt $results_dir/
fi
if [[ $ACPP_VISIBILITY_MASK = *hip* ]]
then
  cd $root_dir/hecbench/src/$APP_NAME-hip
  ./hip $@ > out_native.txt
  mv out_native.txt $results_dir/
fi
if [[ $ACPP_VISIBILITY_MASK = *ocl* ]]
then
  cd $root_dir/hecbench/src/$APP_NAME-sycl
  if [ $APP_DEVICE = 0 ] ; then
    ./icpx-cpu $@ > out_native.txt
  else
    ./icpx $@ > out_native.txt
  fi
  mv out_native.txt $results_dir/
fi
