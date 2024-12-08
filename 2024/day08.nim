import std/[tables, strutils, sequtils]
import utils

type Vec2 = tuple[x, y: int]
proc vec2(x, y: int): Vec2 = (x, y)

proc difference(origin, target: Vec2): Vec2 =
    ## Gets the difference between two points on a 2d plane
    result = vec2(
        target.x - origin.x,
        target.y - origin.y
    )
proc add(a, b: Vec2): Vec2 =
    result = vec2(
        a.x + b.x,
        a.y + b.y
    )

var
    antennas: Table[char, seq[Vec2]]
    antinodes: seq[Vec2]

let
    inputRaw: string = getInput(8).strip()
    inputLines: seq[string] = inputRaw.split("\n")
    areaHeight: int = inputLines.len()
    areaWidth: int = inputLines[0].len()

for row, line in inputLines:
    for col, frequency in line:
        if frequency == '.': continue
        discard antennas.hasKeyOrPut(frequency, @[])
        antennas[frequency].add vec2(col, row)

proc frequencyAntinodes(frequency: char): seq[Vec2] =
    if not antennas.hasKey(frequency):
        raise ValueError.newException("Frequency " & frequency & " unknown.")
    let antennas: seq[Vec2] = antennas[frequency]

    for origin in antennas:
        for target in antennas:
            if origin == target: continue
            let
                diff: Vec2 = origin.difference(target)
                antinode: Vec2 = target.add(diff)
            result.add antinode

proc filteredAntinodes(antinodes: seq[Vec2]): seq[Vec2] =
    for node in antinodes.deduplicate():
        if node.x notin 0 .. areaWidth - 1 or node.y notin 0 .. areaHeight - 1: continue
        result.add node

for frequency, antennas in antennas:
    antinodes.add frequency.frequencyAntinodes()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let partOneSolution: seq[Vec2] = antinodes.filteredAntinodes()
solution(partOneSolution.len(), "Unique antinode locations inside " & $areaWidth & "x" & $areaHeight & " area")
