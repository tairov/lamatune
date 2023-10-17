#!/bin/bash

# define param
run_cmd() {
  output=$("$@" 2>&1)
  # Parse the output to extract metrics
  ops=$(echo "$output" | grep -oE 'tok/s:\s+[0-9]+(\.[0-9]{0,2})?' | awk '{print $2}')
  echo "$output" > output.txt
  # Output the metric (or further process it)
  echo "$ops"
}


run_llama() {
  run_cmd $COMPILED "$MODEL_BIN" $OPTS
}

export -f run_cmd
export -f run_llama
