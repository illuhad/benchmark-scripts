APP_DEVICE=${APP_DEVICE:-1}
ICPX_APP_DEVICE=${ICPX_APP_DEVICE:-0}
SMALL_PROBLEM=${SMALL_PROBLEM:-0}

root_dir=`pwd`
results_dir=$root_dir/results-clover-${RESULT_SUFFIX}
work_dir=$root_dir/cloverleaf/build-acpp
mkdir -p $results_dir

DECK="clover_bm64_short.in"
if [ $SMALL_PROBLEM = 1 ] ; then
  echo "Using small problem size"
  DECK="clover_bm16_short.in"
fi


cd $work_dir
sh $root_dir/run-benchmark.sh ./sycl-acc-cloverleaf --file ../InputDecks/$DECK --device ${APP_DEVICE}
rm -rf $results_dir/*
mv out_al_* $results_dir/
mv errfile.txt $results_dir/

if [[ $ACPP_VISIBILITY_MASK = *cuda* ]]
then
  cd $work_dir/../build-cuda
  ./cuda-cloverleaf  --file ../InputDecks/$DECK > out_native.txt
  mv out_native.txt $results_dir/
fi
if [[ $ACPP_VISIBILITY_MASK = *hip* ]]
then
  cd $work_dir/../build-hip
  ./hip-cloverleaf  --file ../InputDecks/$DECK > out_native.txt
  mv out_native.txt $results_dir/
fi
if [[ $ACPP_VISIBILITY_MASK = *ocl* ]]
then
  cd $work_dir/../build-icpx
  ./sycl-acc-cloverleaf --file ../InputDecks/$DECK --device ${ICPX_APP_DEVICE} > out_native.txt
  mv out_native.txt $results_dir/
fi
