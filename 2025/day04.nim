import std/[strutils]
import utils

using
    input: seq[seq[char]]

let
    initialField: seq[seq[char]] = block:
        var r: seq[seq[char]]
        for i, line in getInputLinesStripped(4):
            if r.len() - 1 < i: r.add @[]
            for c in line:
                r[^1].add c
        r
    lastLine: int = initialField.len() - 1
    lastCol: int = initialField[0].len() - 1

const
    spaceEmpty: char = '.'
    spaceRoll: char = '@'

proc `$$`*(chars: openArray[char]): string =
    for c in chars:
        result &= c

proc itemAt(input; line, col: int): char =
    if line notin 0 .. lastLine: return spaceEmpty
    if col notin 0 .. lastCol: return spaceEmpty
    result = input[line][col]

proc hasLessThanFourRollsNearby(input; line, col: int): bool =
    let # wow idk about this one chief
        upLeft: char = input.itemAt(line - 1, col - 1)
        up: char = input.itemAt(line - 1, col)
        upRight: char = input.itemAt(line - 1, col + 1)

        left: char = input.itemAt(line, col - 1)
        right: char = input.itemAt(line, col + 1)

        downLeft: char = input.itemAt(line + 1, col - 1)
        down: char = input.itemAt(line + 1, col)
        downRight: char = input.itemAt(line + 1, col + 1)

        surroundingList: seq[char] = @[
            upLeft, up, upRight,
            left, right,
            downLeft, down, downRight
        ]
        adjacentRolls: int = count($$surroundingList, spaceRoll)
    result = adjacentRolls < 4


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

proc lessThanFourRollsNearRoll(): int =
    for line in 0 .. lastLine:
        for col in 0 .. lastCol:
            if initialField.itemAt(line, col) == spaceEmpty: continue
            if initialField.hasLessThanFourRollsNearby(line, col): inc result

let solutionPartOne: int = lessThanFourRollsNearRoll()
solution(solutionPartOne, "Rolls with fewer than four rolls nearby")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var shiftingField: seq[seq[char]] = initialField
proc countAllRemovableRolls(): int =
    var previous: int = -1
    while previous != result:
        previous = result
        for line in 0 .. lastLine:
            for col in 0 .. lastCol:
                if shiftingField.itemAt(line, col) == spaceEmpty: continue
                if shiftingField.hasLessThanFourRollsNearby(line, col):
                    inc result
                    shiftingField[line][col] = spaceEmpty

let solutionPartTwo: int = countAllRemovableRolls()
solution(solutionPartTwo, "All removable rolls of paper")
