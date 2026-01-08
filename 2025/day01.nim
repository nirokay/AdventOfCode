import std/[strutils]
import utils

proc getInstructionsIntegers(): seq[int] =
    let instructions: seq[string] = getInputLinesStripped(1)
    result = newSeq[int](instructions.len())
    for i, instruction in instructions:
        let
            sign: int = if instruction[0] == 'L': -1 else: 1
            num: int = parseInt(instruction[1 .. ^1])
        result[i] = sign * num

let instructions: seq[int] = getInstructionsIntegers()

proc simulateSafeLock(simProc: proc(point, r: int): int, startingPoint: int = 50): int =
    var point: int = startingPoint ## current value of lock
    for instruction in instructions:
        point += instruction
        while point notin 0 .. 99:
            if point < 0: point += 100
            elif point > 99: point -= 100
        result = simProc(point, result)

# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

proc part1(point, r: int): int =
    result = r
    if point == 0: inc result

solution(simulateSafeLock(part1, 50), "Times the safe lands on zero")
