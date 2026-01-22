import std/[strutils]
import utils

const
    fieldStart: char = 'S'
    fieldEmpty: char = '.'
    fieldSplit: char = '^'
    fieldBeam: char = '|'

let diagram: seq[string] = getInputLinesStripped(7)


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

proc processBeamSplittingAndCountSplits(): int =
    var field: seq[string] = diagram
    for line, currentLine in field:
        if line == 0: continue
        for col, current in currentLine:
            let above: char = field[line - 1][col]

            proc setCurrent(to: char) = field[line][col] = to
            proc setLeft(to: char) = field[line][col - 1] = to
            proc setRight(to: char) = field[line][col + 1] = to

            # Propagate down:
            case above:
            of fieldEmpty, fieldSplit: continue
            of fieldStart, fieldBeam:
                if current == fieldEmpty: setCurrent fieldBeam
            else: raise ValueError.newException("Illegal character above")

            # Splitter:
            if current != fieldSplit: continue
            inc result
            setLeft fieldBeam
            setRight fieldBeam


let solutionPartOne: tuple[finalField: seq[string], splits: int] = processBeamSplittingAndCountSplits()
solution(solutionPartOne.splits, "Count of all splits")
