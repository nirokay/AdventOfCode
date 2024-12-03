import std/[strutils, algorithm]
import utils

var reports: seq[seq[int]]

for line in getInputLines(2):
    let line: string = line.strip()
    if line == "": continue
    reports.add @[]

    let rawLevels: seq[string] = line.split(" ")
    for rawLevel in rawLevels:
        reports[^1].add rawLevel.parseInt()


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var unsafeReports: seq[int]
for reportId, levels in reports:
    var safe: bool = true
    var differences: seq[int]
    for i, level in levels[1 .. ^1]:
        let prev: int = levels[i]
        differences.add abs(level - prev)

    # Drastic in-/decrement:
    for diff in differences:
        if diff notin 1 .. 3: safe = false
    # Wobbling measurements:
    if levels notin [levels.sorted(Ascending), levels.sorted(Descending)]: safe = false

    if not safe: unsafeReports.add reportId

solution($(reports.len() - unsafeReports.len()) & " / " &  $reports.len(), "Safe reports from the reactor")


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------


