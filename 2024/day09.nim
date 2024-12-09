import std/[options, strutils, strformat]
import utils

let inputRaw: string = getInputStripped(9)

type
    Block = object
        id*: int
    DiskFile = object
        starting*, ending*, length*: int
    Disk = seq[Option[Block]]

proc newDiskFile(starting, ending, length: int): DiskFile =
    result = DiskFile(
        starting: starting,
        ending: ending,
        length: length
    )
    assert ending - starting == length - 1
proc newDiskFile(starting, ending: int): DiskFile = newDiskFile(starting, ending, ending - starting + 1)

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
let largestFileId: int = block:
    var result: int
    for _, fileBlock in originalDisk:
        if fileBlock.isNone(): continue
        let fileBlock: Block = get fileBlock
        if fileBlock.id > result: result = fileBlock.id
    result

proc fileSystemChecksum(disk: Disk): int =
    for position, fileBlock in disk:
        if fileBlock.isNone(): continue
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
solution(partOneSolution, "Checksum of fragmented disk")


# -----------------------------------------------------------------------------
# Part 2:
# -----------------------------------------------------------------------------

proc moveWholeFilesLeft(disk: var Disk) =
    proc findFile(disk: Disk, id: int): DiskFile =
        var
            starting: int = -1
            ending: int = -1
        # Locate continuous file on disk:
        for i in countdown(originalDisk.len() - 1, 0):
            if disk[i].isNone():
                if starting == -1 and ending == -1: continue
                return newDiskFile(starting, ending)
            let fileBlock: Block = get disk[i]
            if fileBlock.id != id: continue
            if ending == -1: ending = i
            starting = i

    proc findSpace(disk: Disk, diskFile: DiskFile): Option[DiskFile] =
        var
            indexStarting: int = -1
            locatedLength: int = 0
        for i, fileBlock in disk:
            # Already past current file position:
            if diskFile.starting <= i: return none DiskFile
            # Occupied:
            if fileBlock.isSome():
                indexStarting = -1
                locatedLength = 0
                continue
            # Found new block of empty space:
            if indexStarting == -1: indexStarting = i
            # Continuous block of empty spaces:
            inc locatedLength
            # Found perfect length, return immediately:
            if locatedLength == diskFile.length:
                return some newDiskFile(indexStarting, indexStarting + locatedLength - 1, locatedLength)

    for id in countdown(largestFileId, 0):
        let
            origin: DiskFile = disk.findFile(id)
            potentialSpace: Option[DiskFile] = disk.findSpace(origin)
        if potentialSpace.isNone(): continue
        let target: DiskFile = get potentialSpace
        for i in 0 .. origin.length - 1:
            disk[target.starting + i] = disk[origin.starting + i]
            disk[origin.starting + i] = none Block
        #echo &"Moving {id} from {origin.starting}..{origin.ending} ({origin.length}) to {target.starting}..{target.ending}"

var notSoVeryCompactedDisk: Disk = originalDisk
notSoVeryCompactedDisk.moveWholeFilesLeft()

let partTwoSolution: int = notSoVeryCompactedDisk.fileSystemChecksum()
solution(partTwoSolution, "Checksum of not fragmented disk")
