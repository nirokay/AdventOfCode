import std/[strutils, math]
import ./printer, ../inputs

type
    Element* = enum
        Rock = 1
        Paper = 2
        Scissors = 3

    Status* = enum
        Loss = 0
        End = 3
        Win = 6


proc getBattleResult(opponent, player: Element): Status =
    if opponent == player:
        return End
    case opponent:
    of Rock:
        if player == Paper: return Win
        else: return Loss
    of Paper:
        if player == Scissors: return Win
        else: return Loss
    of Scissors:
        if player == Rock: return Win
        else: return Loss

proc getScore(element: Element, status: Status): int =
    element.int() + status.int()

proc getMove(c: char): Element {.raises: ValueError.} =
    case c:
    of 'A', 'X': Rock
    of 'B', 'Y': Paper
    of 'C', 'Z': Scissors
    else: raise ValueError.newException("Could not understand charachter '" & $c & "'...")

proc playGame*(moves: seq[array[2, Element]]): seq[int] =
    result = @[0]
    for m in moves:
        let
            opponent: Element = m[0]
            player: Element = m[1]
            status: Status = getBattleResult(opponent, player)
            score: int = getScore(player, status)

        result[^1] += score
        if status == End: result.add(0)


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var part1moves: seq[array[2, Element]]
for line in getInputFile(2).lines():
    var l: string = line.strip()
    part1moves.add(
        [l[0].getMove(), l[^1].getMove()]
    )

var part1scores: seq[int] = part1moves.playGame()
solution(part1scores.sum(), "Total score")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------
proc getDesiredOutcome(c: char): Status {.raises: ValueError.} =
    case c:
    of 'X': Loss
    of 'Y': End
    of 'Z': Win
    else: raise ValueError.newException("Could not understand charachter '" & $c & "'...")

proc getMoves(opponent, outcome: char): tuple[opponent, player: Element] =
    let outcome: Status = outcome.getDesiredOutcome()
    result.opponent = opponent.getMove()
    result.player =
        if outcome == End:
            result.opponent
        else:
            case result.opponent:
            of Rock:
                if outcome == Win: Paper
                else: Scissors
            of Paper:
                if outcome == Win: Scissors
                else: Rock
            of Scissors:
                if outcome == Win: Rock
                else: Paper


var part2moves: seq[array[2, Element]]
for line in getInputFile(2).lines():
    var l: string = line.strip()
    let moves: tuple[opponent, player: Element] = getMoves(l[0], l[^1])
    part2moves.add([moves.opponent, moves.player])

let part2scores: seq[int] = part2moves.playGame()
solution(part2scores.sum(), "Total score of correct strategy")
