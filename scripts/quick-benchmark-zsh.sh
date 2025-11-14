#!/usr/bin/env zsh

# Quick zsh startup benchmark
# Runs zsh 5 times and reports average

echo "Benchmarking zsh startup time (5 runs)..."

for i in {1..5}; do
  /usr/bin/time zsh -i -c exit 2>&1 | tail -1
done | awk '{sum+=$1; n++} END {printf "Average: %.3fs\n", sum/n}'
