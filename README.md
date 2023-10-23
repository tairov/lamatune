### Llama2.c ports/forks benchmarking framwork


<p align="center">
  <img src="assets/bench-demo.gif" width="700" alt="lamatune bench demo">
</p>

Have you ever wanted to benchmark a baby Llama2 models in 12 programming languages? No? Well, now you can!

### How to benchmark 2 branches/PRs of llama2.mojo?

1. Clone this repo
2. Clone & build [hypertune](https://github.com/tairov/hypertune) & make it avaialble in your PATH
4. Edit `config.sh`
```shell
# set workdir that should contain directory `models` with `*.bin` models
export WORKDIR=~/opensource

# optionally set the number of benchmark rounds
export BENCHMARK_ROUNDS=30

# also it's possible to adjust the number of threads
export THREADS=4
```
5. Edit `bench/compare2.sh` change the VERSIONS definition

```shell
VERSIONS=(
  "v1,https://github.com/tairov/llama2.mojo.git,master"
  "v2,git@github.com:andresnowak/llama2.mojo.git,master"
)
```

5. Run `compare2.sh` with bash

**only bash supported for now, since `compare2.sh` uses exported bash functions for passing to `hypertune`**
```shell
bash bench/compare2.sh

```

It will generate report in `/tmp` directory & open it in browser.
