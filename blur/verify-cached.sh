#!/bin/bash
# Author: David Holmqvist <daae19@student.bth.se>

status=0
temp_dir="/tmp/dv1674_a2_cached"

[ -d "$temp_dir" ] || mkdir "$temp_dir" || exit 1

red=$(tput setaf 1)
reset=$(tput sgr0)

for thread in 1 2 4 8 16 32; do
    for image in im1 im2 im3 im4; do
        baseline="$temp_dir/blur_${image}_baseline.ppm"
        [ -f "$baseline" ] || ./blur 15 "data/$image.ppm" "$baseline"

        optimized="$temp_dir/blur_${image}_optimized.ppm"
        ./blur 15 "data/$image.ppm" "$optimized"

        if ! cmp -s "$baseline" "$optimized"; then
            echo "${red}Incongruent output data detected when blurring image $image.ppm with $thread thread(s)${reset}"
            status=1
        fi

        rm "$optimized"
    done
done

exit $status
