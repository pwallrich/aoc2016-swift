import Foundation
import Collections

class Day19: Day {
    var day: Int { 19 }
    let input: Int

    init(testInput: Bool) throws {
        if testInput {
            self.input = 5
        } else {
            self.input = 3001330
        }
    }

    func runPart1() throws {
        var elfs = Array(repeating: 1, count: input)
        var idx = 0
        while true {
            print(idx)
            guard let nextIdx = elfs.nextIdx(after: idx) else {
                print(idx + 1)
                fatalError()
            }
            elfs[idx] += elfs[nextIdx]
            elfs[nextIdx] = 0
            idx = elfs.nextIdx(after: nextIdx)!
        }
    }

    class Elf {
        let number: Int
        var next: Elf!
        var before: Elf!

        init(number: Int) {
            self.number = number
        }
    }

    func createElves() -> (start: Elf, toStealFrom: Elf) {
        let start: Elf = Elf(number: 1)
        var before: Elf = start
        let firstToBeStolenFrom = input / 2

        var toStealFrom: Elf!

        for i in 2...input {
            let elf = Elf(number: i)
            // we're 1 indexed and not zero
            if i == firstToBeStolenFrom + 1 {
                toStealFrom = elf
            }
            before.next = elf
            elf.before = before
            before = elf
        }

        start.before = before
        before.next = start
        return (start, toStealFrom)
    }

    func runPart2() throws {
        var onTable = input
        var (curr, toStealFrom) = createElves()
        while onTable > 1 {
            let before = toStealFrom.before!
            let next = toStealFrom.next!
            before.next = next
            next.before = before

            // The first one who gets presents stolen is sitting opposite to the elf
            // the next one will always be either the next or the second to next one. Depending on whether there was an elf sitting directly in front of the other
            // So if we remove the elves properly from the ring we can just do that, until no elf is left anymore
            if onTable % 2 == 0 {
                toStealFrom = toStealFrom.next
            } else {
                toStealFrom = toStealFrom.next.next
            }
            curr = curr.next

            onTable -= 1
        }

        print(curr.number)
    }
}

fileprivate extension Array where Element == Int {
    func nextIdx(after idx: Int) -> Int? {
        let count = count
        for i in 1..<count {
            if self[(idx + i) % count] != 0 {
                return (idx + i) % count
            }
        }
        return nil
    }
}
