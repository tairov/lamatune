#!/bin/bash
source ./config.sh

# store dir
pushd .

# https://github.com/karpathy/llama2.c
build_karpathy/llama2.c () {
  cd $WORKDIR/llama2.c
  make runomp CC=/opt/homebrew/opt/llvm/bin/clang
  # OMP_NUM_THREADS=5 ./run ../models/stories110M.bin -t 0.0 -n 256
}

# https://github.com/karpathy/llama2.c
build_karpathy/llama2.c-runfast () {
  cd $WORKDIR/llama2.c
  make runfast
  # ./run ../models/stories110M.bin -t 0.0 -n 256
}

# https://github.com/tairov/llama2.mojo
build_tairov/llama2.mojo () {
  cd $WORKDIR/llama2.mojo
  mojo build llama2.mojo
}

# https://github.com/ggerganov/llama.cpp
build_ggerganov/llama.cpp () {
  cd $WORKDIR/llama.cpp
  # build in CPU only mode
  make -j LLAMA_NO_METAL=1
  # system_info: n_threads = 5 / 10 | AVX = 0 | AVX2 = 0 | AVX512 = 0 | AVX512_VBMI = 0 | AVX512_VNNI = 0 | FMA = 0 | NEON = 1 | ARM_FMA = 1 | F16C = 0 | FP16_VA = 1 | WASM_SIMD = 0 | BLAS = 1 | SSE3 = 0 | SSSE3 = 0 | VSX = 0 |
  # ./main -m out/stories110M.bin.gguf -n 256 --temp 0 --threads 5 -s 100
}

# https://github.com/gaxler/llama2.rs
build_gaxler/llama2.rs() {
  cd $WORKDIR/gaxler-llama2.rs
  cargo build --release -F parallel
  # ./target/release/llama2-rs ../models/stories15M.bin 0
}

# https://github.com/leo-du/llama2.rs
build_leo/llama2.rs() {
  cd $WORKDIR/leo-du-llama2.rs
  rustc -C opt-level=3 run.rs -o run
  # ./run ../models/stories15M.bin 0 256
}

# BLAS enabled rust port of llama2
# https://github.com/rahoua/pecca-rs
build_rahoua/pecca-rs() {
  cd $WORKDIR/pecca-rs
  cargo build --release
  # ./target/release/pecca-rs generate ../models/stories15M.bin -t 0 -s 256
}

# https://github.com/nikolaydubina/llama2.go
build_nikolaydubina/llama2.go() {
  cd $WORKDIR/llama2.go
  go build -o run .
  # ./run -checkpoint=../models/stories15M.bin -temperature=0
}

# https://github.com/tmc/go-llama2
build_tmc/go-llama2() {
  cd $WORKDIR/go-llama2/go
  go build .
  # ./llama2 ../../models/stories15M.bin
}

# https://github.com/clebert/llama2.zig
build_clebert/llama2.zig() {
  cd $WORKDIR/llama2.zig
  zig build -Doptimize=ReleaseFast
  # ./zig-out/bin/llama2 ../models/stories15M.bin -t 0 --verbose
}

# https://github.com/cgbur/llama2.zig
build_cgbur/llama2.zig() {
  cd $WORKDIR/cgbur-llama2.zig
  zig build -Doptimize=ReleaseFast
  # ./zig-out/bin/llama2 ../models/stories15M.bin -t 0 -v -n 256
}

# https://github.com/cafaxo/Llama2.jl
build_cafaxo/llama2.jl() {
  cd $WORKDIR/cafaxo-llama2.jl
  # julia main.jl ../models/stories15M.bin
}

# https://github.com/juvi21/llama2.jl
build_juvi21/llama2.jl() {
  cd $WORKDIR/juvi21-llama2.jl
  julia jl_helpers/install_pkg.jl
  # julia run.jl ../models/stories110M.bin tokenizer.bin --temp 0 --steps 256
}

build_karpathy/llama2.c
build_karpathy/llama2.c-runfast
build_tairov/llama2.mojo
build_ggerganov/llama.cpp
build_gaxler/llama2.rs
build_leo/llama2.rs
build_rahoua/pecca-rs
build_nikolaydubina/llama2.go
build_tmc/go-llama2
build_clebert/llama2.zig
build_cgbur/llama2.zig
build_cafaxo/llama2.jl
build_juvi21/llama2.jl

popd