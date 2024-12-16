import std/[strutils, options, tables]
import utils

const mapBounds: int = 52

let
    inputRaw: string = getInputStripped(10)
    inputLines: seq[string] = inputRaw.split("\n")

type
    Map = array[mapBounds, array[mapBounds, int]]
    Vec2 = tuple[row, col: int]
    Journey = seq[Vec2]

proc vec2(row, col: int): Vec2 = (row, col)

proc getSolution(journeys: seq[Journey]): int =
    var startingToSummit: Table[Vec2, seq[Vec2]]
    for journey in journeys:
        let
            starting: Vec2 = journey[0]
            summit: Vec2 = journey[^1]
        if not startingToSummit.hasKey(starting): startingToSummit[starting] = @[]
        if summit in startingToSummit[starting]: continue
        startingToSummit[starting].add summit
    for _, summits in startingToSummit:
        result += summits.len()

let map: Map = block:
    var result: Map
    for row, line in inputLines:
        for col, c in line:
            result[row][col] = parseInt($c)
    result

proc getTerrain(pos: Vec2): int =
    if pos.row notin 0 .. mapBounds - 1 or pos.col notin 0 .. mapBounds - 1:
        result = 9999
        echo "Out of bounds: " & $pos
    else:
        result = map[pos.row][pos.col]

proc getVecTo(initial: Vec2, offRow, offCol: int): Option[Vec2] =
    let
        row = initial.row + offRow
        col = initial.col + offCol
    if row notin 0 .. mapBounds - 1 or col notin 0 .. mapBounds - 1: return none Vec2
    result = some vec2(row, col)
proc left(position: Vec2): Option[Vec2] = position.getVecTo(0, -1)
proc right(position: Vec2): Option[Vec2] = position.getVecTo(0, 1)
proc up(position: Vec2): Option[Vec2] = position.getVecTo(-1 , 0)
proc down(position: Vec2): Option[Vec2] = position.getVecTo(1 , 0)

iterator everyNumber(numbers: varargs[int]): Vec2 =
    for rowId, row in map:
        for colId, height in row:
            if height notin numbers: continue
            yield vec2(rowId, colId)

proc adjacent(pos: Vec2, acceptableChange: seq[int]): seq[Vec2] =
    for direction in [left, right, up, down]:
        let maybeNewPos: Option[Vec2] = pos.direction()
        if maybeNewPos.isNone(): continue
        let newPos: Vec2 = get maybeNewPos
        if newPos.getTerrain() - pos.getTerrain() notin acceptableChange: continue
        result.add newPos

proc travelPath(currentJourney: Journey, completedJourneys: var seq[Journey]) =
    let startingPosition: Vec2 = currentJourney[^1]
    # Got to goal, return:
    if startingPosition.getTerrain() == 9:
        completedJourneys.add currentJourney
        return

    let neighbours: seq[Vec2] = startingPosition.adjacent(@[1])

    # Stuck, return:
    if neighbours.len() == 0: return

    # Travel through neighbouring tiles:
    for neighbour in neighbours:
        let newRoute: Journey = currentJourney & neighbour
        newRoute.travelPath(completedJourneys)


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var partOnePaths: seq[Journey]
for position in everyNumber(0):
    travelPath(@[position], partOnePaths)

for journey in partOnePaths:
    var heights: seq[int]
    for pos in journey:
        heights.add pos.getTerrain()

solution(partOnePaths.getSolution(), "Trails from 0 -> 9 with gradual incline")
