import std/[strformat]

proc getInputFile*(day: int): string =
    var dayString: string =
        if len($day) == 1: "0" & $day
        else: $day
    result = &"./inputs/day{dayString}.input"

proc getInput*(day: int): string =
    let file: string = day.getInputFile()
    result = file.readFile()

