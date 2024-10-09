#!/bin/bash
# Author: David Holmqvist <daae19@student.bth.se>

status=0
temp_dir="/tmp/dv1674_a2_cached"

[ -d "$temp_dir" ] || mkdir "$temp_dir" || exit 1

red=$(tput setaf 1)
reset=$(tput sgr0)

for thread in 1 2 4 8 16 32; do
    for size in 128 256 512 1024; do
        baseline="$temp_dir/pearson_${size}_baseline.data"
        [ -f "$baseline" ] || ./pearson "data/$size.data" "$baseline"

        optimized="$temp_dir/pearson_${size}_optimized.data"
        ./pearson "data/$size.data" "$optimized"

        if ! cmp -s "$baseline" "$optimized"; then
            echo "${red}Incongruent output data detected with size $size and $thread thread(s)${reset}"
            status=1
        fi

        rm "$optimized"
    done
done

exit $status
