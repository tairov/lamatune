#!/bin/bash

# hypertune "./bench-15M.sh" --output=report --export-json=/tmp/bench-15m.json -r 20 -g

# Run the command and capture its output
# -t 0.0 temperature 0 - stable inference
# -n 256 steps
# -s seed number = 100
# -j 5 threads
output=$($WORKDIR/llama2-mojo-prs/llama2.mojo/llama2 stories15M.bin -t 0.0 -n 256 -s 100 -j 1)

# Parse the output to extract metrics
ops=$(echo "$output" | grep '^achieved tok/s:' | awk '{print $3}')

# Output the metric (or further process it)
echo "$ops"
