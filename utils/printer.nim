import std/[strutils, strformat]

const
    borderChar*: char = '#'
    borderTopTextIndent: int = 4

var solutionPartCounter*: int = 1

proc solution*[T](content: T, customMessage: string = "Solution") =
    let borderTopText: string = &" Part {solutionPartCounter}: "

    var
        solution: string = &" {customMessage}:  {content} "
        borderBottom: string = repeat(borderChar, solution.len() + 4)
        borderTop: string = borderBottom
        spacerRow: string = borderChar & repeat('-', solution.len() + 2) & borderChar

    for i, c in borderTopText:
        let textCharIndex: int = i + borderTopTextIndent
        if textCharIndex > borderTop.len() - 1:
            borderTop.add(borderChar)
        borderTop[textCharIndex] = c

    if borderTop[^1] != borderChar: borderTop.add(borderChar)
    while borderTop.len() != borderBottom.len():
        let count: int = borderTop.len() - borderBottom.len()
        borderBottom.add(repeat(borderChar, count))
        solution.insert(repeat(' ', count), solution.len() - 3)


    # Pretty print:
    echo @[
        "\n" & borderTop,
        spacerRow,
        &"{borderChar} {solution} {borderChar}",
        spacerRow,
        borderBottom & "\n"
    ].join("\n")

    # Increase part counter:
    solutionPartCounter.inc()
