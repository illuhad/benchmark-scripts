# Benchmarking scripts

1. Ensure that `acpp` is in the path; for comparing to native model performance, native compilers (`nvcc`, `hipcc`, `icpx`) need to be in path as well.
2. Run `bash ./build-bude.sh; bash ./build-cloverleaf.sh; bash ./build-hecbench.sh`
3. Configure environment variables:
   1. Set `ACPP_VISIBILITY_MASK` to expose only your target backend. For `icpx`, set `SYCL_DEVICE_ALLOWLIST`.
   2. Set `RESULT_SUFFIX` to some identifier of your benchmark run (e.g. hardware). Result files will be placed in the directory `results-$APP_NAME-$RESULT_SUFFIX`
   3. For weaker hardware (e.g. iGPU or CPU), consider setting`SMALL_PROBLEM=1`.
4. Run benchmarks:
   1. `bash ./run-bude.sh`. Set `APP_DEVICE` environment variable to configure the AdaptiveCpp SYCL device index that should be picked.
   2. `bash ./run-cloverleaf.sh`. Set `APP_DEVICE` environment variable to configure the AdaptiveCpp SYCL device index that should be picked
   3. `bash ./run-hecbench.sh`. Set `APP_DEVICE=0` to run on CPU, otherwise a GPU will be picked.
