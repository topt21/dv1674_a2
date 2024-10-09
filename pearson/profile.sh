#!/bin/bash

mkdir -p output/

temp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
red=$(tput setaf 1)
reset=$(tput sgr0)

echo "Profiling for pearson with 1 thread"

for size in 128 256 512 1024; do
    top -bd1 | grep pearson >"output/top_$size.log" &
    # Time
    { time ./pearson "data/$size.data" "$temp_dir/${size}_seq.data"; } 2>"output/runtime_${size}_seq.log"
    kill $(jobs -p)

    # Callgrind
    echo "Running callgrind for size $size..."
    valgrind --tool=callgrind --callgrind-out-file="output/callgrind_${size}.log" ./pearson "data/$size.data" "$temp_dir/${size}_seq.data"

    # Perf
    echo "Running perf for $size..."
    perf record -g -o "output/perf_$size.data" ./pearson "data/$size.data" "$temp_dir/${size}_sec.data"

    # Clean
    rm "$temp_dir/${size}_seq.data"
done

echo "----------------------------------------------------"
echo "Performance profiling for pearson is complete"
