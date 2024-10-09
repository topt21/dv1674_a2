#!/bin/bash

mkdir -p output/

temp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

echo "Running blur with 1 thread "

for image in im1 im2 im3 im4; do

    top -bd1 | grep blur >"output/top_$image.log" &
    # Time
    { time ./blur 15 "data/$image.ppm" "$temp_dir/blur_${image}.ppm"; } 2>"output/runtime_${image}.log"
    kill $(jobs -p)

    # Callgrind
    echo "Running callgrind for $image..."
    valgrind --tool=callgrind --callgrind-out-file="output/callgrind_${image}.log" ./blur 15 "data/$image.ppm" "$temp_dir/blur_${image}.ppm"

    # Callgrind
    echo "Running perf for $image..."
    perf record -g ./blur 15 "data/$image.ppm" "$temp_dir/blur_${image}.ppm"

    # Clean
    rm "$temp_dir/blur_${image}.ppm"

done

echo "----------------------------------------------------"
echo "Performance profiling for ./blur is complete"
