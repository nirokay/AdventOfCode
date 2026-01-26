import std/[strutils, math, algorithm, sequtils]
import utils

type
    JunctionBox = ref object
        id*: string
        x*, y*, z*: int
        circuitId*: int = -1
        closest*: JunctionBox
    Circuit = seq[JunctionBox]

proc `$`(circuit: Circuit): string =
    var ids: seq[string]
    for box in circuit:
        ids.add box.id
    result = ids.join(" & ")

var
    junctionBoxes: seq[JunctionBox]
    circuits: seq[Circuit]

for id, line in getInputLinesStripped(8):
    let parts: seq[string] = line.split(",")
    junctionBoxes.add JunctionBox(
        id: line.strip(),
        x: parts[0].parseInt(),
        y: parts[1].parseInt(),
        z: parts[2].parseInt()
    )


proc distance(a, b: JunctionBox): float =
    result = float(b.x - a.x) ^ 2 + float(b.y - a.y) ^ 2 + float(b.z - a.z) ^ 2
    result = sqrt result

proc sortByDistance(a, b: JunctionBox): int =
    if a.distance(a.closest) < b.distance(b.closest): -1
    elif a.distance(a.closest) > b.distance(b.closest): 1
    else: 0


proc getClosestJunctionBox(current: JunctionBox): JunctionBox =
    var closestDistance: float = 9999999999999.0
    for box in junctionBoxes:
        if box.id == current.id: continue

        let dist: float = distance(current, box)
        if dist > closestDistance: continue

        closestDistance = dist
        result = box
    current.closest = result
    echo current.id & " -> " & result.id & "\t\t(" & $closestDistance & ")"

proc newCircuit(boxA, boxB: JunctionBox) =
    let id: int = circuits.len()
    boxA.circuitId = id
    boxB.circuitId = id
    circuits.add @[boxA, boxB]
    echo "New Circuit: ", id, "  ", circuits[id], "\n"
proc addToCircuit(box: JunctionBox, id: int) =
    box.circuitId = id
    circuits[id].add box
    echo "Connecting:  ", id, "  ", circuits[id], "\n"

for box in junctionBoxes:
    discard box.getClosestJunctionBox()
junctionBoxes.sort(sortByDistance)

proc connectAllJunctionBoxesTogether() =
    for box in junctionBoxes:
        if box.circuitId != -1: continue # skip connected boxes
        let closest: JunctionBox = box.closest

        if closest.circuitId == -1: newCircuit(box, closest)
        else: box.addToCircuit(closest.circuitId)

connectAllJunctionBoxesTogether()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let sortedCircuitSizes: seq[int] = block:
    var r: seq[int]
    for circuit in circuits: r.add circuit.len()
    r.sorted(Descending)

var solutionPartOne: int = 1
for i in sortedCircuitSizes[0 .. 2]:
    solutionPartOne *= i

echo sortedCircuitSizes
solution(solutionPartOne, "Product of top 3 lengths of circuits") # 252 < 800 < ?
