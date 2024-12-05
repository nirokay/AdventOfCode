#!/usr/bin/env bash

GET_INPUT_SCRIPT="./get-input.sh"
[ ! -f "$GET_INPUT_SCRIPT" ] && {
    echo -e "Could not find file '$GET_INPUT_SCRIPT', cannot continue. Exiting."
    exit 1
}

YEAR=$1
[ -z "$YEAR" ] && {
    echo -e "Year is empty, please provide it as \$1 (2015 - 2024+)."
    exit 2
}

for DAY in $(seq 1 25); do
    $GET_INPUT_SCRIPT "$YEAR" "$DAY" &
done
