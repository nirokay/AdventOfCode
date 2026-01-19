import std/[strutils]
import utils

let
    input: seq[seq[char]] = block:
        var r: seq[seq[char]]
        for i, line in getInputLinesStripped(4):
            if r.len() - 1 < i: r.add @[]
            for c in line:
                r[^1].add c
        r
    lastLine: int = input.len() - 1
    lastCol: int = input[0].len() - 1

const
    spaceEmpty: char = '.'
    spaceRoll: char = '@'
    spaceRollTaken: char = 'x'

proc `$$`*(chars: openArray[char]): string =
    for c in chars:
        result &= c

proc itemAt(line, col: int): char =
    if line notin 0 .. lastLine: return spaceEmpty
    if col notin 0 .. lastCol: return spaceEmpty
    result = input[line][col]

proc lessThanFourRollsNearRoll(): int =
    for line in 0 .. lastLine:
        for col in 0 .. lastCol:
            if itemAt(line, col) == spaceEmpty: continue
            let # wow idk about this one chief
                upLeft: char = itemAt(line - 1, col - 1)
                up: char = itemAt(line - 1, col)
                upRight: char = itemAt(line - 1, col + 1)

                left: char = itemAt(line, col - 1)
                right: char = itemAt(line, col + 1)

                downLeft: char = itemAt(line + 1, col - 1)
                down: char = itemAt(line + 1, col)
                downRight: char = itemAt(line + 1, col + 1)

                surroundingList: seq[char] = @[
                    upLeft, up, upRight,
                    left, right,
                    downLeft, down, downRight
                ]
                adjacentRolls: int = block:
                    var r: int
                    for item in surroundingList:
                        if item in [spaceRoll, spaceRollTaken]: inc r
                    r
            if adjacentRolls < 4: inc result


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let solutionPartOne: int = lessThanFourRollsNearRoll()
solution(solutionPartOne, "Rolls with fewer than four rolls nearby")
