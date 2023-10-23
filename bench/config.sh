#!/bin/bash
export WORKDIR=~/projects/opensource

export BENCH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ASSETS_DIR=$(realpath "$BENCH_DIR/../assets/")

export STORIES15M_BIN="$WORKDIR/models/stories15M.bin"
export STORIES110M_BIN="$WORKDIR/models/stories110M.bin"
export THREADS=5
export MODEL_BIN=$STORIES15M_BIN
export BENCHMARK_RUNS=30
export REPORT_TEMPLATE="$ASSETS_DIR/report-template.html"

