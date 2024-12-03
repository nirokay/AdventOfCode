import std/[strutils, math, algorithm]
import utils

var
    locationsLeft: seq[int]
    locationsRight: seq[int]

for line in inputLines(1):
    if line == "": continue
    let split: seq[string] = line.strip().split(" ")
    locationsLeft.add split[0].parseInt()
    locationsRight.add split[^1].parseInt()

locationsLeft.sort(Ascending)
locationsRight.sort(Ascending)
assert locationsLeft.len() == locationsRight.len()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var distances: seq[int]
for i in 0 .. locationsLeft.len() - 1:
    distances.add abs(locationsLeft[i] - locationsRight[i])


solution(distances.sum(), "Total distance between lists")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------


