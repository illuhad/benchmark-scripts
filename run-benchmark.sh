#!/bin/bash

export OMP_PROC_BIND=true

jit_string="kernel_cache: This application run has resulted in new binaries being JIT-compiled."

for i in $(seq 0 2);
do
  echo "Measuring AL $i"
  rm -rf ~/.acpp
  outfile="out_al_$i.txt"
  errfile="errfile.txt"
  echo "" > $errfile
  echo "" > $outfile

  has_converged=false
  num_runs=1
  while [ "$has_converged" != true ]
  do
    allocation_tracking=0
    # Enable Allocation tracking once it is exposed
    # to end users
    #if [ "$i" -gt "0" ] ; then
    #  allocation_tracking=1
    #fi

    echo "[run-benchmark.sh] Running..."
    ACPP_ALLOCATION_TRACKING=$allocation_tracking ACPP_ADAPTIVITY_LEVEL=$i $@ 2> $errfile 1>> $outfile
    grep "$jit_string" $errfile > /dev/null
    if [ $? = 0 ] ; then
      echo "Stil optimizing..."
    else
      echo "JIT-Optimization complete."
      has_converged=true
      echo "#final-num-runs $num_runs" >> $outfile
    fi
    num_runs=$((num_runs+1))
  done
done
