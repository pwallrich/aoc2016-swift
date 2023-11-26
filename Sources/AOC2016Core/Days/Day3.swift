import Foundation
import RegexBuilder
import Algorithms

class Day3: Day {
    var day: Int { 3 }
    let input: String

    let regex = Regex {
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0 )}
        OneOrMore(.whitespace)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0 )}
        OneOrMore(.whitespace)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0 )}
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603
"""
        } else {
            inputString = try InputGetter.getInput(for: 3, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var count = 0
        for match in input.matches(of: regex) {
            if match.1 + match.2 > match.3 && match.2 + match.3 > match.1 && match.1 + match.3 > match.2 {
                count += 1
            }
        }
        print(count)
    }

    func runPart2() throws {
        var count = 0
        let rows = input
            .matches(of: regex)
            .map { [$0.output.1, $0.output.2, $0.output.3] }

        for x in 0..<3 {
            for y in stride(from: 0, through: rows.count - 1, by: 3) {
                let first = rows[y][x]
                let second = rows[y + 1][x]
                let third = rows[y + 2][x]
                if first + second > third && first + third > second && second + third > first {
                    count += 1
                }
            }
            
        }
        
        print(count)
    }
}
