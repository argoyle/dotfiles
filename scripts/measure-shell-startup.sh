#!/usr/bin/env bash

# Measure shell startup time
# Usage: ./measure-shell-startup.sh [iterations]

set -euo pipefail

ITERATIONS=${1:-10}
SHELL_CMD=${2:-zsh}

echo "Measuring ${SHELL_CMD} startup time over ${ITERATIONS} iterations..."
echo

# Measure startup time
total=0
for i in $(seq 1 "$ITERATIONS"); do
  # Use time command to measure shell startup
  result=$( (time $SHELL_CMD -i -c exit) 2>&1 | grep real | awk '{print $2}')

  # Extract seconds
  if [[ $result == *m* ]]; then
    minutes=$(echo "$result" | cut -d'm' -f1)
    seconds=$(echo "$result" | cut -d'm' -f2 | tr -d 's')
    time_in_seconds=$(echo "$minutes * 60 + $seconds" | bc)
  else
    time_in_seconds=$(echo "$result" | tr -d 's')
  fi

  total=$(echo "$total + $time_in_seconds" | bc)
  echo "Iteration $i: ${time_in_seconds}s"
done

average=$(echo "scale=3; $total / $ITERATIONS" | bc)

echo
echo "====================================="
echo "Average startup time: ${average}s"
echo "====================================="
