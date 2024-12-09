import std/[options, strutils, strformat]
import utils

let inputRaw: string = getInputStripped(9)

type
    Block = object
        id*: int
    Disk = seq[Option[Block]]

proc `$`*(component: Option[Block]): string =
    result = block:
        if component.isNone(): "."
        else: "[" & $component.get().id & "]"
proc `$`*(disk: Disk): string =
    result = disk.join("")

let originalDisk: Disk = block:
    var result: Disk
    for i, c in inputRaw:
        let
            isFile: bool = i mod 2 == 0
            fileId: int = i div 2
            length: int = parseInt($c)
            insertedData: Option[Block] = block:
                if isFile: some Block(id: fileId)
                else: none Block
        for _ in 1 .. length:
            result.add insertedData
    result

proc fileSystemChecksum(disk: Disk): int =
    for position, fileBlock in disk:
        if fileBlock.isNone(): break
        result += position * fileBlock.get().id


# -----------------------------------------------------------------------------
# Part 1:
# -----------------------------------------------------------------------------

proc packAllBlocksLeft(disk: var Disk) =
    var farthestDataBlockIndex: int = disk.len() - 1
    iterator locateEmptyIndex(disk: Disk): int =
        for i in 0 .. disk.len() - 1:
            if i >= farthestDataBlockIndex: break
            if disk[i].isSome(): continue
            yield i
    proc moveFarthestDataBlock(disk: var Disk, target: int) =
        for curr in countdown(farthestDataBlockIndex, 0):
            if disk[curr].isNone(): continue

            disk[target] = disk[curr]
            disk[curr] = none Block

            farthestDataBlockIndex = curr
            return
    for emptyId in disk.locateEmptyIndex():
        disk.moveFarthestDataBlock(emptyId)

var veryCompactedDisk: Disk = originalDisk
veryCompactedDisk.packAllBlocksLeft()

let partOneSolution: int = veryCompactedDisk.fileSystemChecksum()
solution(partOneSolution, "Checksum of packed disk")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------


