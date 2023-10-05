import std/[strutils, sets]
import utils

using
    trees: array[99, array[99, int]]

var trees: array[99, array[99, int]]
block `parsing trees into array`:
    var row: int
    for line in getInputLines(8):
        let line = line.strip()
        if line == "": continue
        for i, c in line:
            trees[row][i] = parseInt($c)
        row.inc()

iterator column(trees; col: int, ignore: seq[int] = @[]): tuple[index, height: int] =
    ## Iterates over all elements in a column
    for i in 0 .. 98:
        if i in ignore: continue
        yield (index: i, height: trees[i][col])

iterator row(trees; row: int, ignore: seq[int] = @[]): tuple[index, height: int] =
    ## Iterates over all elements in a row
    for i in 0 .. 98:
        if i in ignore: continue
        yield (index: i, height: trees[row][i])


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var visibleTrees: HashSet[array[2, int]]

# Most inefficient algorithm ever:
for row in 0 .. 98:
    for col in 0 .. 98:
        let
            positions: array[2, int] = [row, col]
            height: int = trees[row][col]

        proc addTree() =
            visibleTrees = visibleTrees + toHashSet([positions])

        # Border trees (automatically visible):
        if 0 in positions or 98 in positions:
            addTree()
            continue

        # Loop over entire row and column (horrible, do not do this):
        var
            blockingRow: seq[int]
            blockingCol: seq[int]

        for result in row(trees, row, @[positions[1]]):
            let
                t: int = result.index
                h: int = result.height
            # Adds tree that would block tree:
            if h >= height: blockingRow.add(t)

        for result in column(trees, col, @[positions[0]]):
            let
                t: int = result.index
                h: int = result.height
            # Adds tree that would block tree:
            if h >= height: blockingCol.add(t)

        # Visible, because only one at maximum is blocking it:
        if blockingCol.len() < 2 or blockingRow.len() < 2:
            addTree()
            continue

        # Visible from one side:
        if blockingRow[0] > positions[1] or blockingRow[^1] < positions[1]:
            addTree()
            continue
        if blockingCol[0] > positions[0] or blockingCol[^1] < positions[0]:
            addTree()
            continue

        # Not visible:
        continue

solution(visibleTrees.len(), "Visible trees from the outside")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

# TODO: Continue this (this challenge has been horrible)

