import std/[strutils, math, algorithm, sequtils, tables]
import utils

let
    inputRaw: string = getInput(7)
    inputLines: seq[string] = inputRaw.strip().split("\n")

type
    Operation = enum
        Multiplication = "*"
        Addition = "+"
        Concatenation = "&"
    Expression = object
        targetValue*: int
        numbers*: seq[int]
        operations*, validOperations*: seq[seq[Operation]]

var cacheTable: Table[string, seq[int]]
proc toBase(number, base: int, minLength: int = 0): seq[int] =
    ## Converts an `int` into a list of digits of base `n`
    let cacheId: string = $number & "@" & $base
    if cacheTable.hasKey(cacheId):
        result = cacheTable[cacheId]
    else:
        result = @[]
        var buffer: int = number
        while buffer > 0:
            let remainder: int = buffer mod base
            buffer = buffer div base
            result.add remainder
        cacheTable[cacheId] = result
    while result.len() < minLength:
        result.add 0
    result.reverse()

var expressions: seq[Expression]
for line in inputLines:
    var result: Expression = Expression()
    let
        splitByColon: seq[string] = line.split(": ")
        strTargetValue: string = splitByColon[0]
        strNumbers: seq[string] = splitByColon[^1].split(" ")

    result.targetValue = strTargetValue.parseInt()
    for number in strNumbers:
        result.numbers.add number.parseInt()

    expressions.add result

proc getAllOperations(expression: Expression, operations: seq[Operation]): seq[seq[Operation]] =
    let
        maxOperations: int = expression.numbers.len() - 1
        maxVarieties: int = operations.len() ^ maxOperations
    if maxOperations < 0:
        raise ValueError.newException("Passed Expression is fucked up:\n" & $expression)

    var count: int
    while true:
        let digits: seq[int] = count.toBase(operations.len(), expression.numbers.len() - 1)
        if unlikely digits.len() >= expression.numbers.len(): break

        result.add @[]
        for digit in digits:
            result[^1].add operations[digit]

        inc count

    assert result.len() == maxVarieties

proc validateOperations(expression: var Expression) =
    for i, operations in expression.operations:
        let originalOperations = operations
        var
            operations: seq[Operation] = originalOperations.reversed()
            numbers: seq[int] = expression.numbers.reversed()
            solution: int = numbers.pop()
        while operations.len() > 0 and numbers.len() > 0:
            let number: int = numbers.pop()
            case operations.pop():
            of Multiplication: solution *= number
            of Addition: solution += number
            of Concatenation:
                # Unsure which operation is quicker:
                solution = parseInt($solution & $number)
                #[
                solution *= (
                    if number div 10_000 > 0: 100_000
                    elif number div 1_000 > 0: 10_000
                    elif number div 100 > 0: 1_000
                    elif number div 10 > 0: 100
                    else: 10
                )
                solution += number
                ]#
        if solution == expression.targetValue:
            expression.validOperations.add originalOperations
            expression.validOperations = expression.validOperations.deduplicate()

proc validateExpressions(solution: var int, operations: seq[Operation]) =
    for i, expression in expressions:
        var newExpression: Expression = expression
        newExpression.operations &= expression.getAllOperations(operations)
        newExpression.validateOperations()
        expressions[i] = newExpression

        if newExpression.validOperations.len() != 0:
            solution += expression.targetValue

        stdout.write "\rValidating number ", i + 1, " / ", expressions.len()
        stdout.flushFile()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var partOneSolution: int
partOneSolution.validateExpressions(@[Multiplication, Addition])
solution(partOneSolution, "Total calibration result")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var partTwoSolution: int
partTwoSolution.validateExpressions(@[Multiplication, Addition, Concatenation]) # Takes a long ass time
solution(partTwoSolution, "Total calibration result with concatenation")
