import std/[strutils, algorithm, math, tables]
import utils

proc `$$`*(bank: seq[int]): string =
    for i in bank:
        result.add $i

var banks: seq[seq[int]]
for line in getInputLinesStripped(3):
    let numbers: seq[int] = block:
        var r: seq[int]
        for c in line:
            r.add parseInt($c)
        r
    banks.add numbers
    assert line == $$numbers

proc findHighestNumberFromIndex(list: Table[int, seq[int]], excludeValues: seq[int], startIndex: int, isStarting: bool): tuple[value, index: int] =
    for value in [9, 8, 7, 6, 5, 4, 3, 2, 1]:
        if value in excludeValues: continue
        if not list.hasKey(value): continue
        for index in list[value]:
            if index > startIndex:
                return (value: value, index: index)

    return (value: 0, index: -1) ## no matches found

proc findHighestJoltageInBank(bank: seq[int], length: Natural = 2): int =
    echo "Attempting bank: " & $$bank & " with Length: " & $length
    var
        highestNumbers: seq[tuple[value, index: int]] ## temp result for digits
        excludeValues: seq[int]
        list: Table[int, seq[int]]

    # Populate list:
    for batteryID, batteryPower in bank:
        if not list.hasKey(batteryPower): list[batteryPower] = @[]
        list[batteryPower].add batteryID

    var currentIndex: int = -1
    while highestNumbers.len() < length:
        stdout.write "\rLength: " & $highestNumbers.len()
        stdout.flushFile()
        let nextHighest: tuple[value, index: int] = findHighestNumberFromIndex(list, excludeValues, currentIndex, highestNumbers.len() == 0)
        highestNumbers.add nextHighest
        currentIndex = nextHighest.index

        if excludeValues.len() != 0: excludeValues.delete(0)

        # Backtrack and exclude number, if needed:
        if highestNumbers[^1].index == -1:
            # Remove non-existent number:
            highestNumbers.delete(highestNumbers.len() - 1)
            # Add number to exclusion list and remove that number from list:
            excludeValues.add highestNumbers[^1].value
            highestNumbers.delete(highestNumbers.len() - 1)
            # Reset index:
            if highestNumbers.len() != 0: currentIndex = highestNumbers[^1].index
            else: currentIndex = -1


    for i, number in highestNumbers.reversed():
        result += number.value * 10^i

    block checkIncreaseInIndex:
        assert highestNumbers.len() == length, "Too few results: " & "\n" & $highestNumbers & "\n(" & $$bank & ")"
        var index: int = -1
        for battery in highestNumbers:
            assert battery.index > index, "Malformed indexes: " & $battery & "\n" & $highestNumbers & "\n(" & $$bank & ")"
            index = battery.index

    stdout.write "\rCompleted bank: " & $$bank & "\n"
    stdout.flushFile()



# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var
    solutionPart1: seq[int]
    solutionPart2: seq[int]
for bank in banks:
    solutionPart1.add bank.findHighestJoltageInBank()
    # solutionPart2.add bank.findHighestJoltageInBank(length = 12)

solution(solutionPart1.sum(), "Total joltage output (2 digits)")
solution(solutionPart2.sum(), "Total joltage output (12 digits)")
