import std/[strutils]
import utils

import weave

const printOutPaths: bool = false
when printOutPaths: import std/[os]

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


let solutionPartOne: int = processBeamSplittingAndCountSplits()
solution(solutionPartOne, "Count of all splits")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

proc processQuantumManyWorlds(lastDiagram: seq[string], posLine, posCol: int): int =
    #echo posLine, " ", posCol
    var currentDiagram: seq[string] = lastDiagram

    for line in posLine .. diagram.len() - 1:
        when printOutPaths:
            if diagram[line][posCol] != fieldSplit: currentDiagram[line][posCol] = fieldBeam
            echo currentDiagram.join("\n") & "\n"
            sleep(10)

        let current: char = diagram[line][posCol]
        if current != fieldSplit: continue
        # Split beam:
        result += 1
        # Left:
        result += currentDiagram.processQuantumManyWorlds(line, posCol - 1)
        # Right:
        result += currentDiagram.processQuantumManyWorlds(line, posCol + 1)

        break


proc processQuantumManyWorldsWorker(lastDiagram: seq[string], posLine, posCol: int): int =
    #echo posLine, " ", posCol
    var currentDiagram: seq[string] = lastDiagram

    for line in posLine .. diagram.len() - 1:
        echo line, " ", posCol
        when printOutPaths:
            if diagram[line][posCol] != fieldSplit: currentDiagram[line][posCol] = fieldBeam
            echo currentDiagram.join("\n") & "\n"
            sleep(10)

        let current: char = diagram[line][posCol]
        if current != fieldSplit: continue
        # Split beam:
        result += 1
        # Left:
        result += currentDiagram.processQuantumManyWorlds(line, posCol - 1)
        # Right:
        result += currentDiagram.processQuantumManyWorlds(line, posCol + 1)

        break

proc processQuantumManyWorldsMultiThreaded(): int =
    result = 1
    init(Weave)
    result += diagram.processQuantumManyWorldsWorker(0, diagram[0].find(fieldStart)) + 1
    exit(Weave)


# let solutionPartTwo: int = diagram.processQuantumManyWorlds(0, diagram[0].find(fieldStart)) + 1
let solutionPartTwo: int = processQuantumManyWorldsMultiThreaded()
solution(solutionPartTwo, "Count of the amount of alternate realities")
