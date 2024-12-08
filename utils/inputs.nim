import std/[strutils, strformat, tables]

var cache: Table[int, string]

proc getInputFile*(day: int): string =
    var dayString: string =
        if len($day) == 1: "0" & $day
        else: $day
    result = &"./.inputs/day{dayString}.input"

proc getInput*(day: int): string =
    if cache.hasKey(day): return cache[day]

    let file: string = day.getInputFile().strip()
    result = file.readFile()

    cache[day] = result
proc getInputStripped*(day: int): string = getInput(day).strip()

proc getInputLines*(day: int): seq[string] =
    let file: string = day.getInput()
    result = file.split("\n")
proc getInputLinesStripped*(day: int): seq[string] =
    let file: string = day.getInputStripped()
    result = file.split("\n")

iterator inputLines*(day: int): string =
    let lines: seq[string] = day.getInputLines()
    for line in lines:
        yield line
iterator inputLinesStripped*(day: int): string =
    for line in inputLines(day):
        yield line.strip()
