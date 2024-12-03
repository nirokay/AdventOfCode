import std/[strutils, algorithm, sequtils]
import utils

var reports: seq[seq[int]]

for line in getInputLines(2):
    let line: string = line.strip()
    if line == "": continue
    reports.add @[]

    let rawLevels: seq[string] = line.split(" ")
    for rawLevel in rawLevels:
        reports[^1].add rawLevel.parseInt()

proc isReportSafe(levels: seq[int]): bool =
    result = true
    var differences: seq[int]
    for i, level in levels[1 .. ^1]:
        let prev: int = levels[i]
        differences.add abs(level - prev)

    # Drastic in-/decrement:
    for diff in differences:
        if diff notin 1 .. 3: result = false
    # Wobbling measurements:
    if levels notin [levels.sorted(Ascending), levels.sorted(Descending)]: result = false


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

var unsafeReports: seq[int]
for reportId, levels in reports:
    if not levels.isReportSafe(): unsafeReports.add reportId

let firstPartSolution: int = reports.len() - unsafeReports.len()
solution($firstPartSolution & " / " &  $reports.len(), "Safe reports from the reactor")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

var nevermindActuallySafeTrustMeBro: seq[int]

proc recheckSafety(reportId: int): bool =
    var actualSafety: seq[bool]
    let levels: seq[int] = reports[reportId]

    for i in 0 .. levels.len() - 1:
        var newLevels: seq[int] = levels
        newLevels.delete(i)
        actualSafety.add newLevels.isReportSafe()

    result = true in actualSafety

for id in unsafeReports:
    let safe: bool = id.recheckSafety()
    if safe: nevermindActuallySafeTrustMeBro.add id

let partTwoSolution: int = firstPartSolution + nevermindActuallySafeTrustMeBro.len()
solution($partTwoSolution & " / " &  $reports.len(), "Nvm, actually safe reports from the reactor")

