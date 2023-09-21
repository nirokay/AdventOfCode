import std/[strutils]

import ../inputs

var elves: seq[seq[int]]

elves.add(@[])
for line in getInputFile(1).lines():
    # "Increase Index" but cooler:
    if line.strip() == "":
        elves.add(@[])
        continue

    # Add to list as int:
    elves[^1].add(line.parseInt())

proc sum*[T](s: seq[T]): T =
    for i in s:
        result += i

var elvesSum*: seq[int]
for elf in elves:
    elvesSum.add(elf.sum())

echo elvesSum.max()

