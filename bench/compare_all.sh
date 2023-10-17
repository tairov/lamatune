#!/bin/bash +x

source ./config.sh
source ./funcs.sh
source ./run_funcs.sh

# source ./build_all.sh

#export tempdir=$(mktemp -d)
export tempdir='/tmp'
pushd .

cd $tempdir

# --prepare "" # runs before each individual timing run
# --cleanup "" # runs after each set of runs finished
# -L compiler gcc,clang '{compiler} -O2 main.cpp'

run_setup() {
  # ver = $1
  model=$2
  export MODEL_BIN="$WORKDIR/models/$model"
}

export -f run_setup

#IMPLEMENTATIONS='karpathy-llama2.c,tairov-llama2.mojo,ggerganov-llama.cpp,gaxler-llama2.rs,leo-du-llama2.rs,rahoua-pecca-rs,nikolaydubina-llama2.go,tmc-go-llama2,clebert-llama2.zig,cgbur-llama2.zig,cafaxo-llama2.jl,juvi21-llama2.jl'
IMPLEMENTATIONS='karpathy-llama2.c'
PARAM_MODELS='stories15M.bin,stories42M.bin,stories110M.bin'

DT=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="/tmp/compare_all_${DT}.json"

hypertune "run_{ver} {model}" \
-L ver $IMPLEMENTATIONS -L model $PARAM_MODELS \
-r $BENCHMARK_RUNS -g \
--output=report \
--setup='run_setup {ver} {model}' \
--export-json=$REPORT_FILE

# threads = 1
export THREADS=1
DT=$(date +%Y%m%d-%H%M%S)
REPORT_FILE2="/tmp/compare_all_${DT}_single_thread.json"

hypertune "run_{ver} {model}" \
-L ver $IMPLEMENTATIONS -L model $PARAM_MODELS \
-r $BENCHMARK_RUNS -g \
--output=report \
--setup='run_setup {ver} {model}' \
--export-json=$REPORT_FILE2


echo "Benchmark finished. Report file: $REPORT_FILE"
echo "Benchmark finished. Report file: $REPORT_FILE2"

popd
