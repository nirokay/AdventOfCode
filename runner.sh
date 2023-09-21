#!/usr/bin/env bash
YEAR=$1
DAY=$2

FILE_SOLUTION="day$DAY.nim"
[ ! -f "./$YEAR/$FILE_SOLUTION" ] && FILE_SOLUTION="day0$DAY.input"

cd "$YEAR" || echo "could not cd into dir"
nim r --hints:off "$FILE_SOLUTION"
cd "$STARTING_DIR" || echo "could not cd back out of dir"
