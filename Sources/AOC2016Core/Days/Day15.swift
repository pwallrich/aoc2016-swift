import Foundation
import RegexBuilder

class Day15: Day {
    var day: Int { 15 }
    let input: String

    let regex = Regex {
        "has "
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
"""
        } else {
            inputString = try InputGetter.getInput(for: 15, part: .first)
        }
        self.input = inputString
    }

    struct Disc {
        let positions: Int
        var current: Int

        mutating func increase() {
            current = (current + 1) % positions
        }
    }

    func runPart1() throws {
        var discs: [Disc] = []
        for match in input.matches(of: regex) {
            print(match.1, match.2, match.3)
            discs.append(.init(positions: match.1, current: match.3))
        }

        let targets = discs.enumerated().map { ($0.element.positions - 1 - $0.offset) % $0.element.positions }

        var steps = 0
        while true {
            print(steps)
            let firstMatches = zip(discs, targets).map {
                (($0.0.positions + $0.1) - $0.0.current - (steps % $0.0.positions)) % $0.0.positions
            }

            if firstMatches.reduce(0, +) == 0 {
                print(steps)
                return
            }
            steps += firstMatches.max()!
        }
    }

    func runPart2() throws {
        var discs: [Disc] = []
        for match in input.matches(of: regex) {
            print(match.1, match.2, match.3)
            discs.append(.init(positions: match.1, current: match.3))
        }

        discs.append(.init(positions: 11, current: 0))

        let targets = discs.enumerated().map { ($0.element.positions - 1 - $0.offset) % $0.element.positions }

        var steps = 0
        while true {
            print(steps)
            let firstMatches = zip(discs, targets).map {
                (($0.0.positions + $0.1) - $0.0.current - (steps % $0.0.positions)) % $0.0.positions
            }

            if firstMatches.reduce(0, +) == 0 {
                print(steps)
                return
            }
            steps += firstMatches.max()!
        }
    }
}

fileprivate extension Array where Element == Day15.Disc {
    func isValid() -> Bool {
        for (idx, disc) in self.enumerated() {
            if disc.current != disc.positions - (idx + 1) {
                return false
            }
        }
        return true
    }
}
