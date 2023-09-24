import std/[strutils, options]
import ./printer, ../inputs

let input: string = getInput(6).strip()

# Horrible function, which at this point does literal magic...
# I do not remember what half of the stuff does anymore
proc firstDistinctChars(input: string, length: int): tuple[str: Option[string], index: int] =
    result = (none string, -1) # Default return
    var
        starting: int = 0
        check: seq[char]

    # IndexDefect-be-gone loop:
    while starting + length <= input.len() - 1:
        # Loop over
        for i, c in input[starting .. starting + length - 1]:
            # Horrible debug traceback:
            # echo ((if c in check: "!!!\t" else: ":)\t") & $check & "  +  " & $c).replace("'$1'" % [$c], "#$1#" % [$c])

            if c in check:
                # Short sequence after newly added, duplicate char:
                check = check[check.find(c) + 1 .. ^1]
            # Add new char to sequence:
            check.add(c)

        if check.len() == length:
            echo "Without duplicates: " & $check
            return (some check.join(""), starting)

        starting.inc()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let startOfPacketMarker: tuple[str: Option[string], index: int] = input.firstDistinctChars(4)

solution(startOfPacketMarker.index + 4, "Start of packet marker")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

let startOfMessageMarker: tuple[str: Option[string], index: int] = input.firstDistinctChars(14)

solution(startOfMessageMarker.index + 14, "Start of message marker")
