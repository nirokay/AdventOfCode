import std/[strutils]
import utils

var
    freshIngredients: seq[HSlice[int, int]]
    ingredients: seq[int]
    stillParsingRanges: bool = true

for i, line in getInputLinesStripped(5):
    # Ranges of fresh ingredients:
    if line == "":
        stillParsingRanges = false
        continue
    if stillParsingRanges:
        let splitValues: seq[string] = line.split("-")
        assert splitValues.len() == 2, "Line does not include valid fresh ingredient range: " & line
        let
            idStart: int = splitValues[0].parseInt()
            idEnd: int = splitValues[1].parseInt()
        freshIngredients.add idStart .. idEnd
    else:
        let ingredient: int = line.parseInt()
        ingredients.add ingredient

proc isFresh(ingredient: int): bool =
    for range in freshIngredients:
        if ingredient in range: return true

proc getFreshIngredients(): seq[int] =
    for ingredient in ingredients:
        if ingredient.isFresh(): result.add ingredient


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

let allFreshIngredients: seq[int] = getFreshIngredients()
solution(allFreshIngredients.len(), "Count of all fresh ingredients in the database")
