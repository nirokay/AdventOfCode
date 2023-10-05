import std/[strutils]
import utils


var schedules: seq[array[2, array[2, int]]]
for line in inputLines(4):
    if line == "": continue

    let split: seq[string] = line.strip().split(',')
    if split.len() != 2: raise ValueError.newException("More/Less than 2 schedules found in $1" % [line])

    schedules.add(@[[[0, 0], [0, 0]]])
    for i, sections in split:
        let index: seq[string] = sections.split('-')
        schedules[^1][i] = [parseInt(index[0]), parseInt(index[^1])]



# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

proc hasCompleteSubset(s1, s2: array[2, int]): bool =
    # Same startin/ending section IDs:
    if s1[0] == s2[0] or s1[1] == s2[1]: return true

    # s1 includes s2:
    if s2[0] in s1[0] .. s1[1] and s2[1] in s1[0] .. s1[1]: return true

    # s2 includes s1:
    if s1[0] in s2[0] .. s2[1] and s1[1] in s2[0] .. s2[1]: return true


var completeSubsetCount: int
for schedule in schedules:
    if hasCompleteSubset(schedule[0], schedule[1]):
        completeSubsetCount.inc()
        echo schedule

solution(completeSubsetCount, "Comple work subsets found")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

proc overlaps(s1, s2: array[2, int]): bool =
    # Same starting/ending sections:
    if s1[0] in [s2[0], s2[1]] or s1[1] in [s2[0], s2[1]]: return true

    # Overlaps:
    if s2[0] in s1[0] .. s1[1] or s2[1] in s1[0] .. s1[1]: return true
    if s1[0] in s2[0] .. s2[1] or s1[1] in s2[0] .. s2[1]: return true


var schedulesWithOverlaps: int
for schedule in schedules:
    if overlaps(schedule[0], schedule[1]): schedulesWithOverlaps.inc()

solution(schedulesWithOverlaps, "Schedule with overlaps")
