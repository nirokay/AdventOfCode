import std/[strutils, math, re]
import utils

let
    memory: string = getInput(3).strip()
    pattern: Regex = re"mul\(\d{1,3},\d{1,3}\)"

var expressions: seq[string]
for expression in memory.findAll(pattern):
    expressions.add expression

var multiplications: seq[array[2, int]]
for expression in expressions:
    let
        commaSeparated: seq[string] = expression.split(",")
        left: string = commaSeparated[0].split("(")[^1]
        right: string = commaSeparated[^1].split(")")[0]
    multiplications.add [left.parseInt(), right.parseInt()]

# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var results: seq[int]
for expression in multiplications:
    results.add expression[0] * expression[1]

solution(results.sum(), "Sum of all multiplications")
