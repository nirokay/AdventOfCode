import std/[strutils, tables, algorithm, math]
import utils

let
    inputRaw: string = getInput(5).strip()
    inputSplit: seq[string] = inputRaw.split("\n\n")
    inputPageOrderingRules: seq[string] = inputSplit[0].strip().split("\n")
    inputPageUpdates: seq[string] = inputSplit[1].strip().split("\n")

type SortOrder = object
    value*: int
    preceding*, following*: seq[int]
var sortRules: Table[int, SortOrder]

for line in inputPageOrderingRules:
    let
        numbers: seq[string] = line.split("|")
        x: int = numbers[0].parseInt() # Must be before `y`
        y: int = numbers[1].parseInt() # Must be after `x`

    if not sortRules.hasKey(x): sortRules[x] = SortOrder(value: x)
    if not sortRules.hasKey(y): sortRules[y] = SortOrder(value: y)
    sortRules[x].following.add y
    sortRules[y].preceding.add x

proc sortCorrectly(valX, valY: int): int =
    let
        x: SortOrder = sortRules[valX]
        y: SortOrder = sortRules[valY]

    result = block:
        if x.value == y.value: 0
        elif x.value in y.preceding: -1
        elif x.value in y.following: 1
        elif y.value in x.preceding: 1
        elif y.value in x.following: -1
        else:
            echo "WTF"
            0

proc getMiddleValue[T](list: seq[T]): T =
    assert list.len() mod 2 == 1
    let middleIndex: int = list.len() div 2
    result = list[middleIndex]


var updateRules: seq[seq[int]]
for line in inputPageUpdates:
    updateRules.add @[]
    let splitValues: seq[string] = line.strip().split(",")
    for value in splitValues:
        updateRules[^1].add value.parseInt()


# -----------------------------------------------------------------------------
# Part 1 & 2:
# -----------------------------------------------------------------------------

var
    partOneSolutions: seq[int]
    partTwoSolutions: seq[int]
for rule in updateRules:
    let correctRule: seq[int] = rule.sorted(sortCorrectly)
    if rule != correctRule:
        partTwoSolutions.add correctRule.getMiddleValue()
        continue
    partOneSolutions.add rule.getMiddleValue()

solution(partOneSolutions.sum(), "Sum of all middle indices")
solution(partTwoSolutions.sum(), "Sum of all corrected middle indices")
