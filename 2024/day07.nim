import std/[strutils, math, bitops, algorithm, sequtils]
import utils

let
    inputRaw: string = getInput(7)
    inputLines: seq[string] = inputRaw.strip().split("\n")

type
    Operation = enum
        Multiplication = "*"
        Addition = "+"
    Expression = object
        targetValue*: int
        numbers*: seq[int]
        operations*, validOperations*: seq[seq[Operation]]

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

    for iteration in 0 .. maxVarieties - 1: # 0001
        result.add @[]
        let bitsLength: int = int ceil(log2(float maxVarieties + 1))
        for pos in 0 .. bitsLength: # 000[1]
            result[^1].add(
                if iteration.testBit(pos): Multiplication
                else: Addition
            )
    # "Fixing" bugs:
    for i, operations in result:
        result[i] = operations[0 .. expression.numbers.len() - 2]
        assert expression.numbers.len() == result[i].len() + 1
    result = result.deduplicate()
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
        if solution == expression.targetValue: expression.validOperations.add originalOperations


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var partOneSolution: int

for i, expression in expressions:
    var newExpression: Expression = expression
    newExpression.operations = expression.getAllOperations(@[Multiplication, Addition])
    newExpression.validateOperations()
    expressions[i] = newExpression

    if newExpression.validOperations.len() != 0:
        partOneSolution += expression.targetValue

    stdout.write "\rValidating number ", i + 1, " / ", expressions.len()
    stdout.flushFile()

solution(partOneSolution, "Total calibration result")

