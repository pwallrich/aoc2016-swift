import Foundation

class Day20: Day {
    var day: Int { 20 }
    let input: String
    let lastValid: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
5-8
0-2
4-7
"""
            lastValid = 9
        } else {
            inputString = try InputGetter.getInput(for: 20, part: .first)
            lastValid = 4_294_967_295
        }
        self.input = inputString
    }

    func runPart1() throws {
        var ranges: [ClosedRange<Int>] = []
        for row in input.split(separator: "\n") {
            let numbers = row.split(separator: "-")
            let from = Int(numbers[0])!
            let to = Int(numbers[1])!
            ranges.append(from...to)
        }
        ranges.sort { $0.lowerBound < $1.lowerBound }
        var curr = 0
        outer:
        while curr < lastValid {
            print("testing \(curr)")
            for range in ranges {
                if range.contains(curr) {
                    curr = range.upperBound + 1
                    continue outer
                }
            }
            print("found \(curr)")
            return
        }
        fatalError()

    }

    func runPart2() throws {
        var ranges: [ClosedRange<Int>] = []
        var blocked = 0
        for row in input.split(separator: "\n") {
            let numbers = row.split(separator: "-")
            let from = Int(numbers[0])!
            let to = Int(numbers[1])!
            ranges.append(from...to)

        }

        ranges.sort { $0.lowerBound < $1.lowerBound }

        var new: [ClosedRange<Int>] = []

        var idx = 1
        var toCombine: ClosedRange<Int> = ranges[0]

        for range in ranges.dropFirst() {
            if toCombine.overlaps(range) {
                toCombine = min(toCombine.lowerBound, range.lowerBound)...max(toCombine.upperBound, range.upperBound)
            } else {
                new.append(toCombine)
                toCombine = range
            }
        }

        new.append(toCombine)

        print(new.reduce(0) { $0 + $1.count })
        print(lastValid - new.reduce(0) { $0 + $1.count } + 1)
    }
}
