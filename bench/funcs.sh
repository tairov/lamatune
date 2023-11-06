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


gen_report() {
  RESULTS="$1"
  if [[ $(uname) == "Darwin" ]]; then
    # macOS (BSD sed)
    RESID=$(md5 -r $RESULTS | cut -c1-4)
  else
    # Linux (GNU sed)
    RESID=$(md5sum $RESULTS | cut -c1-4)
  fi

  REPORT="/tmp/hypertune-report-$RESID.html"
  echo "" > $REPORT
  LN=$(grep -Fn "'---DATA_POINTS---';" $REPORT_TEMPLATE | cut -d':' -f1)
  LN=$(($LN - 1))
  head -n $LN $REPORT_TEMPLATE >> $REPORT
  echo "const data_points = " >> $REPORT;
  cat $RESULTS >> $REPORT
  echo ";" >> $REPORT
  tail -n +$(($LN + 2)) $REPORT_TEMPLATE >> $REPORT

  # build string <h4>str</h4> from VERSIONS array
  VERSIONS_STR=""
  {
    for ver in "${VERSIONS[@]}" ; do
        IFS=',' read -ra PARTS <<< "$ver"
        VERSION="${PARTS[0]}"
        URL="${PARTS[1]}"
        BRANCH="${PARTS[2]:-master}" # If branch is not set, default to 'master'
        VERSIONS_STR="$VERSIONS_STR<h4>$VERSION: $URL ($BRANCH)</h4>"
    done
  } < /dev/null

  ORIGINAL_STR='<!-- VERSIONS -->'
  REPL='s#'$ORIGINAL_STR'#'$VERSIONS_STR'#g'

  # replace "<!-- VERSIONS -->" to a string $VERSIONS_STR
  if [[ $(uname) == "Darwin" ]]; then
    # macOS (BSD sed)
    sed -i '.bak' "$REPL" $REPORT
  else
      # Linux (GNU sed)
      sed -i "$REPL" "$REPORT"
  fi

  echo $REPORT
}

export -f run_cmd
export -f gen_report
