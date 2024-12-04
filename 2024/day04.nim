import std/[strutils, math, re]
import utils

let
    inputRaw: string = getInput(4).strip()
    inputLines: seq[string] = inputRaw.split("\n")

var solutionBoard: seq[string] = inputRaw.toLower().split("\n")

type
    Line* = array[140, char]
    Puzzle* = array[140, Line]

let puzzle: Puzzle = block:
    var result: Puzzle
    for lineNumber, lineString in inputLines:
        let lineString: string = lineString.strip()
        if lineString == "": continue
        for cIndex, character in lineString:
            result[lineNumber][cIndex] = character
    result

proc countPatternOnLine(pattern: string): int =
    for line in inputLines:
        let finds: seq[string] = line.findAll(re pattern, 0)
        result += finds.len()

proc countPatternDown(pattern: string, shiftSideways: int = 0): int =
    for row, line in inputLines:
        for col, c in line:
            var foundPattern: seq[char] = @[c]
            try:
                var
                    x: int = row
                    y: int = col
                while foundPattern.len() < pattern.len():
                    inc x
                    y += shiftSideways

                    let foundCharacter: char = inputLines[x][y]
                    foundPattern.add foundCharacter
            except IndexDefect:
                continue
            if foundPattern.join("") == pattern: inc result



#[
proc countPatternDown(pattern: string, shiftSideways: int = 0): int =
    for column, line in inputLines:
        for row, c in line:
            if c != pattern[0]:
                continue
            echo "  CHECKING for " & pattern
            echo pattern[0]
            var valid: bool = true
            for i, c in pattern[1 .. ^1]:
                let columnDown: int = column + i + 1
                let rowDown: int = row + shiftSideways * i
                if columnDown >= inputLines.len():
                    valid = false
                    continue
                if rowDown >= inputLines[0].len() or rowDown < 0:
                    valid = false
                    continue
                if inputLines[columnDown][rowDown] != c:
                    valid = false
                echo c & " (" & $i & ")"
            if valid:
                echo "    YAY"
                inc result
            else: echo "    NOPE!"
]#

# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let partOneSolution: int = sum @[
    countPatternOnLine("XMAS"),   # ➡️
    countPatternOnLine("SAMX"),   # ⬅️

    countPatternDown("XMAS"),     # ⬇️
    countPatternDown("SAMX"),     # ⬆️

    countPatternDown("XMAS", 1),  # ↘️
    countPatternDown("XMAS", -1), # ↙️
    countPatternDown("SAMX", 1),  # ↗️
    countPatternDown("SAMX", -1)  # ↖️
]

solution(partOneSolution, "Sum of all 'XMAS' occurrences")
# too low: 1168, 1660
