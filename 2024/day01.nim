import std/[strutils, math, algorithm, tables]
import utils

var
    leftLocations: seq[int]
    rightLocations: seq[int]

for line in inputLines(1):
    if line == "": continue
    let split: seq[string] = line.strip().split(" ")
    leftLocations.add split[0].parseInt()
    rightLocations.add split[^1].parseInt()

leftLocations.sort(Ascending)
rightLocations.sort(Ascending)
assert leftLocations.len() == rightLocations.len()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var distances: seq[int]
for i in 0 .. leftLocations.len() - 1:
    distances.add abs(leftLocations[i] - rightLocations[i])


solution(distances.sum(), "Total distance between lists")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var
    leftCount: CountTableRef[int] = newCountTable(leftLocations)
    rightCount: CountTableRef[int] = newCountTable(rightLocations)
    similarities: seq[int]

for number, leftOccurrences in leftCount:
    let rightOccurrences: int = if rightCount.hasKey(number): rightCount[number] else: 0
    similarities.add number * rightOccurrences

solution(similarities.sum(), "Similarity score between both lists")
