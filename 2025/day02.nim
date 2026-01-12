import std/[strutils, math]
import utils

var
    invalidIDsPart1: seq[int]
    invalidIDsPart2: seq[int]


proc twoHalvesRepeat(id: string): bool =
    if id.len() == 1: return false
    let middle: int = id.len() div 2 - 1
    var
        firstHalf: string
        lastHalf: string
    if id.len() mod 2 == 0:
        firstHalf = id[0 .. middle]
        lastHalf = id[middle + 1 .. ^1]
    else:
        return false
        # firstHalf = id[0 .. middle]
        # lastHalf = id[middle + 2 .. ^1]

    # echo id, " -> ", firstHalf, ", ", lastHalf
    result = firstHalf == lastHalf

proc hasRepeatingPattern(id: string): bool =
    if id.len() == 1: return false
    for length in 0 .. (id.len() - 1) div 2:
        let
            pattern: string = id[0 .. length]
            repeatTimes: int = (id.len() - pattern.len()) div pattern.len() + 1
            constructedNumber: string = pattern.repeat(repeatTimes)
        if id == constructedNumber:
            echo id, " -> ", pattern, " x", repeatTimes, "\t", constructedNumber
            return true


for idRange in getInputStripped(2).split(","):
    let
        ids: seq[string] = idRange.split("-")
        idFirst: int = ids[0].parseInt()
        idLast: int = ids[1].parseInt()
    for id in idFirst .. idLast:
        let idStr: string = $id

        # Part 1:
        if idStr.twoHalvesRepeat(): invalidIDsPart1.add(id)

        # Part 2:
        if idStr.hasRepeatingPattern(): invalidIDsPart2.add(id)


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

solution(invalidIDsPart1.sum(), "Sum of all invalid IDs (two halves)")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

solution(invalidIDsPart2.sum(), "Sum of all invalid IDs (repeating pattern")
