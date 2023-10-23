#!/bin/bash
export WORKDIR=~/projects/opensource

export BENCH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export ASSETS_DIR=$(realpath "$BENCH_DIR/../assets/")

export THREADS=5
export BENCHMARK_ROUNDS=30
export REPORT_TEMPLATE="$ASSETS_DIR/report-template.html"

