import std/[strutils, options, sequtils, algorithm]
import ../inputs, ./printer

proc getCharValue(c: char): int =
    let offset =
        if c.isLowerAscii(): 96
        elif c.isUpperAscii(): 64 - 26
        else: raise ValueError.newException("Ascii character is neither upper, nor lowercase!")
    result = int(c) - offset
assert getCharValue('a') == 1 and getCharValue('z') == 26
assert getCharValue('A') == 27 and getCharValue('Z') == 52

proc splitMiddle(word: string): seq[string] =
    let length: int = word.len() div 2
    result = @[word[0 .. length - 1], word[length .. ^1]]
assert splitMiddle("helloworld") == @["hello", "world"]

proc getRepeatingCharOption(words: seq[string]): Option[char] =
    var matchAgainst: seq[char]
    for c in words[0]:
        if c notin matchAgainst: matchAgainst.add(c)

    # This is horrible:
    var deleteList: seq[int]
    for i, c in matchAgainst:
        for word in words:
            if c notin word: deleteList.add(i)
    deleteList = deleteList.deduplicate()
    deleteList.sort(Descending)
    for i in deleteList:
        matchAgainst.delete(i)

    if matchAgainst.len() == 0: return none char
    if matchAgainst.len() > 1: echo "Found multiple repeating chars ($1)!" % [matchAgainst.join(", ")]
    return some matchAgainst[0]

proc getRepeatingChar(words: seq[string]): char {.raises: ValueError.} =
    let repeating: Option[char] = getRepeatingCharOption(words)
    if repeating.isNone():
        raise ValueError.newException("No repeating chars found. Option is empty!")
    result = get repeating


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var sumOfRepeating: int
for line in inputLines(3):
    if line == "": continue
    let words = line.strip().splitMiddle()
    sumOfRepeating += words.getRepeatingChar().getCharValue()

solution(sumOfRepeating, "Sum of all repeating characters")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var
    sumOfAllBagdes: int
    groupWords: seq[seq[string]] = @[@[]]

# Three words per badge group:
for line in inputLines(3):
    if line == "": continue
    if groupWords[^1].len() == 3: groupWords.add(@[])

    groupWords[^1].add(line.strip())
assert groupWords[^1].len() == 3

for words in groupWords:
    sumOfAllBagdes += words.getRepeatingChar().getCharValue()

solution(sumOfAllBagdes, "Sum of all three-grouped elf-badges")
