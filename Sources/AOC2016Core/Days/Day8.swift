import Foundation
import RegexBuilder

class Day8: Day {
    var day: Int { 8 }
    let input: [Substring]
    let height: Int
    let width: Int

    let numberRegex = Regex {
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
rect 3x2
rotate column x=1 by 1
rotate row y=0 by 4
rotate column x=1 by 1
"""
            height = 3
            width = 7
        } else {
            inputString = try InputGetter.getInput(for: 8, part: .first)
            height = 6
            width = 50
        }
        self.input = inputString.split(separator: "\n")
    }

    func runPart1() throws {
        var grid: Set<Position2D> = []
        for row in input {
            guard let numbers = row.firstMatch(of: numberRegex) else {
                fatalError("Unknown instruction")
            }
            print(numbers.output.1, numbers.output.2)
            if row.starts(with: "rect") {
                for y in 0..<numbers.output.2 {
                    for x in 0..<numbers.output.1 {
                        let point = Position2D(x: x, y: y)
                        grid.insert(point)
                    }
                }
            } else if row.starts(with: "rotate column") {
                let column = numbers.output.1
                let amount = numbers.output.2
                let oldPoints = grid.filter { $0.x == column }
                let newPoints = oldPoints
                    .map { Position2D(x: $0.x, y: ($0.y + amount) % height) }
                for point in oldPoints {
                    grid.remove(point)
                }
                for point in newPoints {
                    grid.insert(point)
                }
            } else if row.starts(with: "rotate row") {
                let row = numbers.output.1
                let amount = numbers.output.2

                let oldPoints = grid.filter { $0.y == row }
                let newPoints = oldPoints
                    .map { Position2D(x: ($0.x + amount) % width, y: $0.y) }
                for point in oldPoints {
                    grid.remove(point)
                }
                for point in newPoints {
                    grid.insert(point)
                }
            } else {
                fatalError("Unknown instruction")
            }
            grid.prettyPrint(width: width, height: height)
        }
        print(grid.count)
    }

    func runPart2() throws {}
}

private extension Set where Element == Position2D {
    func prettyPrint(width: Int, height: Int) {
        for y in 0..<height {
            for x in 0..<width {
                let doesContain =  self.contains(Position2D(x: x, y: y))
                print(doesContain ? "#" : " ", terminator: "")
            }
            print("")
        }
        print("")
    }
}