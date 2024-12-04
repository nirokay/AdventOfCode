import std/[strutils, math, re]
import utils

let
    inputRaw: string = getInput(4).strip()
    inputLines: seq[string] = inputRaw.split("\n")


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

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


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

proc countXShapedMas(): int =
    for row, line in inputLines:
        for col, c in line:
            if c != 'A': continue
            try:
                let
                    leftUp: char = inputLines[row - 1][col - 1]
                    leftDown: char = inputLines[row + 1][col + 1]
                    rightUp: char = inputLines[row + 1][col - 1]
                    rightDown: char = inputLines[row - 1][col + 1]
                    chars: seq[char] = @[leftUp, leftDown, rightUp, rightDown]
                if 'X' in chars or 'A' in chars: continue # Includes 'X':  1) go fuck yourself Elon Musk  2) invalid
                if leftUp == leftDown or rightUp == rightDown: continue # not "MAS": "MAM" or "SAS" -> invalid
            except IndexDefect:
                continue
            inc result

solution(countXShapedMas(), "Sum of all X-'MAS' occurrences")
