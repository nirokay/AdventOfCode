#!/usr/bin/env bash
STARTING_DIR=$(pwd)

YEAR=$1
DAY=$2

# Create inputs dir for year, if missing:
[ ! -d ".inputs/" ] && {}
[ ! -d ".inputs/$YEAR/" ] && mkdir ".inputs/$YEAR/" && touch ".inputs/$YEAR/.gitkeep"

[[ ! -f ".inputs/$YEAR/day$DAY.input" && ! -f ".inputs/$YEAR/day0$DAY.input" ]] && {
    echo -e "Fetshing input for year $YEAR day $DAY..."
    ./get-input.sh $YEAR $DAY || echo -e "Subprocess for fetching failed."
}

# Nim solution file:
FILE_SOLUTION="day$DAY.nim"
[ ! -f "./$YEAR/$FILE_SOLUTION" ] && FILE_SOLUTION="day0$DAY.input"

# In year directory:
cd "$YEAR" || { echo "could not cd into dir"; exit 1; }
[ ! -d ".inputs/" ] && ln -s ../.inputs/$YEAR/ .inputs
[ ! -d ".inputs/" ] && { echo -e "Failed to create inputs symlink, giving up."; exit 1; }

# Nim:
nim r --hints:off "$FILE_SOLUTION"

cd "$STARTING_DIR" || echo "could not cd back out of dir"
