#!/bin/bash

source ./config.sh
source ./funcs.sh

# builds & compares 2 versions of llama2

V1="https://github.com/tairov/llama2.mojo.git"
# custom branch to comapare 2
V2="https://github.com/tairov/llama2.mojo.git"

#export tempdir=$(mktemp -d)
export tempdir='/tmp'
pushd .
cd $tempdir

run_checkout() {
  git clone $V1 v1
  git clone $V2 v2
}

run_v1() {
  cd $tempdir/v1/
  COMPILED=$tempdir/v1/llama2
  OPTS="-t 0.0 -n 256 -s 100 -j $THREADS"
  run_llama
}

run_v2() {
  cd $tempdir/v2/
  COMPILED=$tempdir/v2/llama2
  OPTS="-t 0.0 -n 256 -s 100 -j $THREADS"
  run_llama
}

#run_checkout

run_setup() {
  cd $tempdir/$1
  mojo build llama2.mojo
#  if [ "$1" = 'v1' ]; then
#    #
#  elif [ "$1" = 'v2' ]; then
#    #
#  fi
}

export -f run_v1
export -f run_v2
export -f run_setup

# --prepare "" # runs before each individual timing run
# --cleanup "" # runs after each set of runs finished
# -L compiler gcc,clang '{compiler} -O2 main.cpp'
hypertune "run_{ver}" \
-L ver v1,v2 \
--output=report \
--export-json=/tmp/compare2.json \
--setup='run_setup {ver}' \
-r $BENCHMARK_RUNS -g

popd
