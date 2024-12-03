import std/[strutils, math, re]
import utils

let
    memory: string = getInput(3).strip()
    part1pattern: Regex = re"mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)"

var expressions: seq[string]
for expression in memory.findAll(part1pattern):
    expressions.add expression

proc parseInstructions*(enableConditions: bool): seq[array[2, int]] =
    var skipInstructions: bool = false
    for expression in expressions:
        case expression:
        of "do()": skipInstructions = false
        of "don't()": skipInstructions = true
        else:
            if enableConditions and skipInstructions: continue
            let
                commaSeparated: seq[string] = expression.split(",")
                left: string = commaSeparated[0].split("(")[^1]
                right: string = commaSeparated[^1].split(")")[0]
            result.add [left.parseInt(), right.parseInt()]


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var solutionPartOne: seq[int]
for expression in parseInstructions(enableConditions = false):
    solutionPartOne.add expression[0] * expression[1]

solution(solutionPartOne.sum(), "Sum of all multiplications")

# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var solutionPartTwo: seq[int]
for expression in parseInstructions(enableConditions = true):
    solutionPartTwo.add expression[0] * expression[1]

solution(solutionPartTwo.sum(), "Sum of all multiplications with conditions")

