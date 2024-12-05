#!/usr/bin/env bash

SESSION_ID_FILE=".session-id"
[ ! -f "$SESSION_ID_FILE" ] && {
    echo -e "Session ID file at '$SESSION_ID_FILE' does not exits, could not get token"
    exit 1
}
SESSION_ID=$(cat "$SESSION_ID_FILE")

YEAR=$1
RAW_DAY=$2


[ -z "$YEAR" ] && {
    echo -e "Year is empty, please provide it as \$1 (2015 - 2024+)."
    exit 2
}
[ -z "$RAW_DAY" ] && {
    echo -e "Day is empty, please provide it as \$2 (01 - 25)."
    exit 2
}

SHORT_DAY=$(( RAW_DAY + 0 ))
LONG_DAY=$SHORT_DAY
if [ $SHORT_DAY -lt 10 ]; then
    LONG_DAY="0${SHORT_DAY}"
fi

DIR=".inputs/${YEAR}"
FILE="${DIR}/day${LONG_DAY}.input"
[ ! -d "$DIR" ] && {
    mkdir "$DIR"
    touch "$DIR/.gitkeep"
}

[ ! -d "$YEAR" ] && mkdir "$YEAR"
[ ! -f "$YEAR/utils.nim" ] && echo -e "import ../utils/utils\nexport utils" > "$YEAR/utils.nim"
[ ! -d "$YEAR/.inputs" ] && {
    ln -s "$(realpath "./.inputs/$YEAR")" "$(realpath .)/.inputs"
}

URL="https://adventofcode.com/${YEAR}/day/${SHORT_DAY}/input"
echo -e "Requesting from '$URL'..."
curl --cookie "session=${SESSION_ID}" "$URL" > "$FILE" || {
    echo -e "Request failed"
    exit 1
}
echo -e "Saved to file '$FILE'!"
