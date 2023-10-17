#!/bin/bash

# hypertune "./bench-15M.sh" --output=report --export-json=/tmp/bench-15m.json -r 20 -g

# Run the command and capture its output
# -t 0.0 temperature 0 - stable inference
# -n 256 steps
# -s seed number = 100
# -j 5 threads
run_cmd $WORKDIR/llama2 $MODEL -t 0.0 -n 256 -s 100 -j 1

