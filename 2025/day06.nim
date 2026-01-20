import std/[strutils]
import utils

var unparsed: seq[seq[string]]
for i, line in getInputLinesStripped(6):
    if unparsed.len() - 1 != i: unparsed.add @[]
    let split: seq[string] = line.split(" ")
    for item in split:
        if item == "": continue
        unparsed[^1].add item


type Assignment = object
    operation*: string
    values*: seq[int]
    endResult*: int

var assignments: seq[Assignment] = newSeq[Assignment](unparsed[0].len())
for line in unparsed[0 .. ^2]:
    for id, item in line:
        assignments[id].values.add item.parseInt()
for id, item in unparsed[^1]:
    assignments[id].operation = item


proc calculateAssignment(assignment: var Assignment) =
    assignment.endResult = assignment.values[0]
    for number in assignment.values[1 .. ^1]:
        case assignment.operation:
        of "+": assignment.endResult += number
        of "*": assignment.endResult *= number
        else: raise ValueError.newException("Operation '" & assignment.operation & "' is not supported")

for id, _ in assignments:
    assignments[id].calculateAssignment()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var solutionPartOne: int
for assignment in assignments:
    solutionPartOne += assignment.endResult

solution(solutionPartOne, "Sum of all assignment results") # 2577426 < ?
