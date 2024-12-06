import std/[strutils, options]
import utils

let
    inputRaw: string = getInput(6).strip()
    inputLines: seq[string] = inputRaw.split("\n")

type
    AreaTile = enum
        Empty = '.',
        VisitedPath = 'X',
        Obstacle = '#',
        GuardUp = '^',
        GuardLeft = '<',
        GuardDown = 'v',
        GuardRight = '>'
    Map = array[130, array[130, AreaTile]]
    Vec2 = tuple[row, col: int]
    AreaMap = object
        map*: Map
        shouldContinue*: bool = true
        currGuardLocation*: Vec2
        prevGuardLocation*: Option[Vec2]

proc `$`*(map: Map): string =
    for line in map:
        for tile in line:
            result.add (
                case tile:
                of Empty: "."
                of VisitedPath: "X"
                of Obstacle: "#"
                of GuardUp: "^"
                of GuardLeft: "<"
                of GuardDown: "v"
                of GuardRight: ">"
            )
        result.add "\n"


proc isGuard(tile: AreaTile): bool =
    result = tile in [GuardUp, GuardLeft, GuardDown, GuardRight]

proc parseCharacter(c: char): AreaTile =
    result = case c:
        of '.': Empty
        of 'X': VisitedPath
        of '#': Obstacle
        of '^': GuardUp
        of '<': GuardLeft
        of 'v': GuardDown
        of '>': GuardRight
        else:
            echo "WTF"
            Empty
proc parseMap(lines: seq[string]): AreaMap =
    for row, line in lines:
        for col, c in line:
            let tile: AreaTile = c.parseCharacter()
            result.map[row][col] = tile
            if tile.isGuard(): result.currGuardLocation = (row, col)
proc countTiles(area: AreaMap, tiles: varargs[AreaTile]): int =
    for line in area.map:
        for tile in line:
            if tile in tiles: inc result
proc getRotation(tile: AreaTile): AreaTile =
    if unlikely(not tile.isGuard()):
        raise ValueError.newException("Passed tile is not a guard!")
    result = case tile:
        of GuardUp: GuardRight
        of GuardRight: GuardDown
        of GuardDown: GuardLeft
        of GuardLeft: GuardUp
        else: tile # this should never happen
proc positiveNegativeMovement(tile: AreaTile): Vec2 =
    result = case tile:
        of GuardUp: (0, -1)
        of GuardLeft: (-1, 0)
        of GuardDown: (0, 1)
        of GuardRight: (1, 0)
        else: (0, 0)
proc executeGuardMovement(area: var AreaMap) =
    let
        starting: Vec2 = area.currGuardLocation
        guard: AreaTile = area.map[starting.row][starting.col]

    if not guard.isGuard():
        assert guard == VisitedPath
        area.shouldContinue = false
        return

    let
        move: Vec2 = positiveNegativeMovement(guard)
        infront: Vec2 = (starting.row + move.col, starting.col + move.row)
    try:
        let tile: AreaTile = area.map[infront.row][infront.col]
        if tile == Obstacle:
            # Rotate, do not move:
            area.map[starting.row][starting.col] = guard.getRotation()
            area.prevGuardLocation = none Vec2
        else:
            # Move in direction, set path behind:
            area.map[starting.row][starting.col] = VisitedPath
            area.map[infront.row][infront.col] = guard
            area.currGuardLocation = infront
            if area.prevGuardLocation.isSome():
                let prev: Vec2 = get area.prevGuardLocation
                area.map[prev.row][prev.col] = VisitedPath

            area.prevGuardLocation = some starting
        return
    except IndexDefect:
        echo "oops"
        area.shouldContinue = false
        area.map[starting.row][starting.col] = VisitedPath
        return

proc simulate(area: var AreaMap) =
    echo "Simulation..."
    area.shouldContinue = true
    while area.shouldContinue:
        area.executeGuardMovement()
        #echo $area.map
        #sleep 2


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var area: AreaMap = inputLines.parseMap()
area.simulate()

solution(area.countTiles(VisitedPath), "Unique locations visited by the guard")
