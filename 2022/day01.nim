import std/[strutils, strformat, algorithm]
import utils

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


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

solution(elvesSum.max(), "Elf with most snacks")

# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var elvesSumSorted: seq[int] = elvesSum
elvesSumSorted.sort()

solution(&"{elvesSumSorted[^1] + elvesSumSorted[^2] + elvesSumSorted[^3]}", "Total snacks of top three elves")
