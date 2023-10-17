#!/bin/bash

# https://github.com/karpathy/llama2.c
run_karpathy-llama2.c() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/llama2.c
  if [ "$THREADS" == "1" ]; then
    run_cmd ./run_fast $MODEL_BIN -t 0 -n 256
    return
  fi
  export OMP_NUM_THREADS=$THREADS
  run_cmd ./run $MODEL_BIN -t 0 -n 256
}

#run_karpathy-llama2.c-runfast() {
#  MODEL_BIN=$WORKDIR/models/$1
#  cd $WORKDIR/llama2.c
#  run_cmd ./run_fast $MODEL_BIN -t 0 -n 256
#}

# https://github.com/tairov/llama2.mojo
run_tairov-llama2.mojo() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/llama2.mojo
  run_cmd ./llama2 $MODEL_BIN -t 0 -n 256 -s 100 -j $THREADS
}

# https://github.com/ggerganov/llama.cpp
run_ggerganov-llama.cpp() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/llama.cpp
  # check path in $MODEL_BIN if last name == stories15M.bin, substitude to out/stories15M.bin.gguf
  GMODEL=${MODEL_BIN}.gguf
  # built in CPU only mode
  # system_info: n_threads = 5 / 10 | AVX = 0 | AVX2 = 0 | AVX512 = 0 | AVX512_VBMI = 0 | AVX512_VNNI = 0 | FMA = 0 | NEON = 1 | ARM_FMA = 1 | F16C = 0 | FP16_VA = 1 | WASM_SIMD = 0 | BLAS = 1 | SSE3 = 0 | SSSE3 = 0 | VSX = 0 |
  ./main -m $GMODEL -n 256 --temp 0 --threads $THREADS -s 100 2>&1 \
  | grep "tokens per second" | tail -n 1 \
  | grep -oE '\s[0-9]+(\.[0-9]+)?\s+tokens per second' | awk '{print $1}'
}

# https://github.com/gaxler/llama2.rs
run_gaxler-llama2.rs() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/gaxler-llama2.rs
  ./target/release/llama2-rs $MODEL_BIN 0 2>&1 \
  | grep -oE '[0-9]+(\.[0-9]{0,2})?\d?\sTokens/Sec' | awk '{print $1}'
}

# https://github.com/leo-du/llama2.rs
run_leo-du-llama2.rs() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/leo-du-llama2.rs
  run_cmd ./run $MODEL_BIN 0 256
}

# BLAS enabled rust port of llama2
# https://github.com/rahoua/pecca-rs
run_rahoua-pecca-rs() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/pecca-rs
  run_cmd ./target/release/pecca-rs generate $MODEL_BIN -t 0 -s 256
}

# https://github.com/nikolaydubina/llama2.go
run_nikolaydubina-llama2.go() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/llama2.go
  run_cmd ./run -checkpoint=$MODEL_BIN -temperature=0 -threads=$THREADS -steps=256
}

# https://github.com/tmc/go-llama2
run_tmc-go-llama2() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/go-llama2/go
  run_cmd ./llama2 $MODEL_BIN
}

# https://github.com/clebert/llama2.zig
run_clebert-llama2.zig() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/llama2.zig
  ./zig-out/bin/llama2 $MODEL_BIN -t 0 --verbose 2>&1 | grep -oE 'achieved: [0-9]+(\.[0-9]{0,2})?' | awk '{print $2}'
}

# https://github.com/cgbur/llama2.zig
run_cgbur-llama2.zig() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/cgbur-llama2.zig
  ./zig-out/bin/llama2 $MODEL_BIN -t 0 -v -n 256 2>&1 | grep -oE '[0-9]+(\.[0-9]+)?\s+tokens per second' | awk '{print $1}'
}

# https://github.com/cafaxo/Llama2.jl
run_cafaxo-llama2.jl() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/cafaxo-llama2.jl
  run_cmd julia main.jl $MODEL_BIN
}

# https://github.com/juvi21/llama2.jl
run_juvi21-llama2.jl() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $WORKDIR/juvi21-llama2.jl
  run_cmd julia run.jl $MODEL_BIN tokenizer.bin --temp 0 --steps 256
}

export -f run_karpathy-llama2.c
#export -f run_karpathy-llama2.c-runfast
export -f run_tairov-llama2.mojo
export -f run_ggerganov-llama.cpp
export -f run_gaxler-llama2.rs
export -f run_leo-du-llama2.rs
export -f run_rahoua-pecca-rs
export -f run_nikolaydubina-llama2.go
export -f run_tmc-go-llama2
export -f run_clebert-llama2.zig
export -f run_cgbur-llama2.zig
export -f run_cafaxo-llama2.jl
export -f run_juvi21-llama2.jl
