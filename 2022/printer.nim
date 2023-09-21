import std/[strutils]

const borderChar: char = '#'

proc solution*[T](content: T, customMessage: string = "Solution") =
    let
        solution: string = customMessage & ": " & $content
        length: int = solution.len()

        border: string = repeat(borderChar, length + 4)

    echo "\n$1\n$2 $3 $2\n$1\n" % [border, $borderChar, solution]
