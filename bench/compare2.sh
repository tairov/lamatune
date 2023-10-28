#!/bin/bash

source ./config.sh
source ./funcs.sh

export tempdir='/tmp'
pushd .

VERSIONS=(
  "v1,https://github.com/tairov/llama2.mojo.git,master"
  "v2,git@github.com:mikowals/llama2.mojo.git,batch-matmul"
)

cd $tempdir

run_checkout() {
  {
    for ver in "${VERSIONS[@]}" ; do
        IFS=',' read -ra PARTS <<< "$ver"
        VERSION="${PARTS[0]}"
        URL="${PARTS[1]}"
        BRANCH="${PARTS[2]:-master}" # If branch is not set, default to 'master'

        echo "Checking out $VERSION from $URL branch $BRANCH"
        git clone -b "$BRANCH" "$URL" "$tempdir/$VERSION"
    done
  } < /dev/null
}

run_v1() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $tempdir/v1/
  run_cmd ./llama2 $MODEL_BIN -t 0 -n 256 -s 100 -j $THREADS
}

run_v2() {
  MODEL_BIN=$WORKDIR/models/$1
  cd $tempdir/v2/
  run_cmd ./llama2 $MODEL_BIN -t 0 -n 256 -s 100 -j $THREADS
}

run_checkout

run_setup() {
  if [ "$1" == "v1" ]; then
    cd $tempdir/v1/
    mojo build llama2.mojo
  elif [ "$1" == "v2" ]; then
    cd $tempdir/v2/
    mojo build llama2.mojo
  fi;
}

export -f run_v1
export -f run_v2
export -f run_setup

run_setup v1
# if exit code is not 0, exit
if [ $? -ne 0 ]; then
  echo "Error building v1"
  exit 1
fi

run_setup v2
# if exit code is not 0, exit
if [ $? -ne 0 ]; then
  echo "Error building v2"
  exit 1
fi

IMPLEMENTATIONS='v1,v2'
PARAM_MODELS='stories15M.bin,stories42M.bin,stories110M.bin'

hypertune "run_{ver} {model}" \
-L ver $IMPLEMENTATIONS -L model $PARAM_MODELS \
--output=report \
--export-json=/tmp/compare2.json \
-r $BENCHMARK_ROUNDS -g

REP_FILE=$(gen_report /tmp/compare2.json)
open $REP_FILE

popd
