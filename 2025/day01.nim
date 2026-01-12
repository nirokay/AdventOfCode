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


# -----------------------------------------------------------------------------
# Part 1 & 2:
# -----------------------------------------------------------------------------

var
    solutionPart1: int = 0
    solutionPart2: int = 0 # i have to come back to this one day lol

proc simulateSafeLock(startingPoint: int = 50) =
    var point: int = startingPoint ## current value of lock
    for i, instruction in instructions:
        point += instruction
        while point notin 0 .. 99:
            inc solutionPart2
            # echo i, " !!! (", instruction ,") : ", point
            if point < 0: point += 100
            elif point > 99: point -= 100

        # echo i, ": ", point
        if point == 0: inc solutionPart2
        if point == 0: inc solutionPart1

simulateSafeLock()

solution(solutionPart1, "Times the safe lands on zero")
# solution(solutionPart2, "Time the safe passes zero [INCORRECT]") # < 7243 < 7983 < 8411
