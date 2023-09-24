import std/[strutils]
import ../inputs, ./printer

var crates: array[9, seq[char]]
block `initial position of crates`:
    let rawCratesString: string = getInput(5).split("\n\n")[0].replace("    ", " [_]")

    var rawCratesLines: seq[string] = rawCratesString.split("\n")[0 .. ^2]
    for i, line in rawCratesLines:
        rawCratesLines[i] = line.replace("[", "").replace("]", "").strip() # -> "A B C D E F G H I"

    var rawCrates: seq[seq[string]]
    for line in rawCratesLines:
        rawCrates.add(line.split(' '))

    for column in 0 .. crates.len() - 1:
        for row in countdown(rawCratesLines.len() - 1, 0):
            let c: char = rawCrates[row][column][0]
            if c == '_': break
            crates[column].add(c)

proc runInstructions(crates: array[9, seq[char]], instructions: seq[string], isCrateMover9001: bool = false): array[9, seq[char]] =
    result = crates
    for instruction in instructions:
        let
            temp: seq[string] = instruction.strip().split(" ")
            amount: int = temp[1].parseInt()
            origin: int = temp[3].parseInt() - 1
            destination: int = temp[5].parseInt() - 1

        var buffer: seq[char]
        if isCrateMover9001:
            for current in 0 ..< amount:
                buffer.add(result[origin].pop())
            while buffer != @[]:
                result[destination].add(buffer.pop())
        else:
            for current in 0 ..< amount:
                buffer.add(result[origin].pop())
                result[destination].add(buffer.pop())

proc getTopOfEveryStack(crates: array[9, seq[char]]): string =
    for column in crates:
        result &= $column[^1]

let instructions: seq[string] = getInput(5).split("\n\n")[1].strip().split("\n")


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let cratesAfterSorting: array[9, seq[char]] =
    crates.runInstructions(instructions)

solution(cratesAfterSorting.getTopOfEveryStack(), "Top crates from each stack")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

let cratesAfterSortingWithCrateMover9001: array[9, seq[char]] =
    crates.runInstructions(instructions, isCrateMover9001 = true)

solution(cratesAfterSortingWithCrateMover9001.getTopOfEveryStack(), "Top crates from each stack, when moved with crate mover 9001")
