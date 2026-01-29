import std/[strutils]
import utils

type Machine = ref object
    lights*, targetLights*: seq[bool]
    buttons*: seq[seq[int]]
    joltages*: seq[int]

proc isTurnedOff(machine: Machine): bool =
    result = true
    for light in machine.lights:
        if light: return false

proc parseMachineNumbers(input: string): seq[int] =
    let parts: seq[string] = input.split(",")
    for part in parts:
        result.add part.parseInt()
proc parseMachineLights(input: string): seq[bool] =
    result = newSeq[bool](input.len())
    for i, c in input:
        case c:
        of '.': result[i] = false
        of '#': result[i] = true
        else: raise ValueError.newException("Unexpected light state in '" & input & "': '" & c & "'")

var machines: seq[Machine]
for id, line in getInputLinesStripped(10):
    machines.add Machine()
    let parts: seq[string] = line.split(" ")
    for part in parts:
        let cleaned: string = part[1 .. ^2]
        case part[0]:
        # Lights:
        of '[':
            machines[^1].lights = newSeq[bool](cleaned.len()) # empty current state
            machines[^1].targetLights = cleaned.parseMachineLights() # target state
        # Buttons:
        of '(': machines[^1].buttons.add cleaned.parseMachineNumbers()
        # Joltages:
        of '{': machines[^1].joltages = cleaned.parseMachineNumbers()
        else: raise ValueError.newException("Unexpected character '" & part[0] & "' at line " & $id & ": '" & line & "'")

proc solve(machine: Machine): int =
    if not machine.isTurnedOff(): machine.lights = newSeq[bool](machine.targetLights.len()) # turn off if was on by whatever
    if machine.lights == machine.targetLights: return 0 # let us hope this ever happens :3

echo "idfk how to do this lol, but i at least parse it hehe"
