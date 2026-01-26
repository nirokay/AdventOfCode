import std/[strutils]
import utils

type Tile = tuple[x, y: int]
proc newTile(x, y: int): Tile = (x: x, y: y)


var tiles: seq[Tile]
for line in getInputLinesStripped(9):
    let parts: seq[string] = line.split(",")
    tiles.add newTile(parts[0].parseInt(), parts[1].parseInt())


proc findArea(tileA, tileB: Tile): int =
    let
        x: array[2, int] = [tileA.x, tileB.x]
        y: array[2, int] = [tileA.y, tileB.y]
        length: int = abs(x.max() - x.min()) + 1
        height: int = abs(y.max() - y.min()) + 1
    result = length * height

proc findLargestArea(): int =
    for tileA in tiles:
        for tileB in tiles:
            if tileA == tileB: continue
            let area: int = tileA.findArea(tileB)
            if area > result: result = area


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let solutionPartOne: int = findLargestArea()
solution(solutionPartOne, "Largest possible rectangle area")
