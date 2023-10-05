import std/[strutils, options, tables]
import utils

type Command* = object
    command*: string
    args*: Option[string] = none string
    output*: seq[string] ## Lines of output

var commands: seq[Command]

for line in getInputLines(7):
    if line == "": continue
    let split: seq[string] = line.strip().split(' ')
    # Possible `split` contents:
    # ==========================
    # Commands:
    #   @[0: "$", 1: "cd", 2: "directory"]
    #   @[0: "$", 1: "ls"]
    #
    # Outputs:
    #   @[0: "dir",      1: "dirname"]
    #   @[0: "filesize", 1: "filename"]

    if split[0] == "$":
        # New command:
        commands.add(Command(
            command: split[1])
        )
        if split.len() <= 3:
            commands[^1].args = some split[2 .. ^1].join(" ")

    else:
        # Command output:
        commands[^1].output.add(line.strip())


var filesystem: Table[string, seq[string]]

var currentDirectory: seq[string] = @[""] # ?== @[""] -> in root dir "/"
for command in commands:
    case command.command:
    of "cd":
        let destination: string = command.args.get()
        if destination == "..": discard currentDirectory.pop() # navigate up
        elif destination == "/": currentDirectory = @[""]      # navigate to root
        else: currentDirectory.add(destination)                # navigate to sub-directory
    of "ls":
        let content: seq[string] = command.output
        filesystem[currentDirectory.join("/")] = content
    else: raise ValueError.newException("Unknown command '" & command.command & "'!")

proc getSizeOfDir(path: string): int =
    ## Recursively gets the size of the directory and its subdirectories
    for item in filesystem[path]:
        let split: seq[string] = item.split(" ")
        if split[0] == "dir": result += getSizeOfDir("$1/$2" % [path, split[1]])
        else: result += split[0].parseInt()


var
    sumOfAtMost100000: int
    directorySizes: seq[int]

for dir, contents in filesystem:
    let size: int = dir.getSizeOfDir()
    directorySizes.add(size) # sneakily adding dir sizes for part 2
    if size > 100_000: continue
    sumOfAtMost100000 += size

# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

solution(sumOfAtMost100000, "Sum of directory sizes with at most 100000 size")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

const
    totalSize: int = 70_000_000
    neededSize: int = 30_000_000

let
    occupied: int = getSizeOfDir("")
    needsFreeing: int = neededSize - (totalSize - occupied)

var couldBeDeleted: seq[int]
for size in directorySizes:
        if size >= needsFreeing:
            couldBeDeleted.add(size)

solution(couldBeDeleted.min(), "Smallest directory, that would free up '" & $needsFreeing & "' is")
