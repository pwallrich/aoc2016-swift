import Foundation

class Day2: Day {
    var day: Int { 2 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
ULL
RRDDD
LURDL
UUUUD
"""
        } else {
            inputString = try InputGetter.getInput(for: 2, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        let digits = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
        ]
        var current = Position2D(x: 1, y: 1)
        var result: [Int] = []
        for (idx, row) in input.components(separatedBy: "\n").enumerated() {
            print("generating digit \(idx)")

            for char in row {
                var deltaX = 0
                var deltaY = 0
                switch char {
                case "U": deltaY = -1
                case "D": deltaY = 1
                case "L": deltaX = -1
                case "R": deltaX = 1
                default: fatalError("Invalid input")
                }
                if (0...2 ~= current.x + deltaX) && (0...2 ~= current.y + deltaY) {
                    current = Position2D(x: current.x + deltaX, y: current.y + deltaY)
                }
            }
            print("found \(digits[current.y][current.x])")
            result.append(digits[current.y][current.x])
        }
        print(result)
    }

    func runPart2() throws {
        let digits = [
            [nil,    nil,    "1",    nil,     nil],
            [nil,     "2",     "3",     "4",      nil],
            ["5",       "6",     "7",     "8",       "9" ],
            [nil,     "A",     "B",     "C",      nil],
            [nil,    nil,    "D",    nil,      nil],
        ]
        var current = Position2D(x: 1, y: 1)
        var result: [String] = []
        for (idx, row) in input.components(separatedBy: "\n").enumerated() {
            print("generating digit \(idx)")

            for char in row {
                var deltaX = 0
                var deltaY = 0
                switch char {
                case "U": deltaY = -1
                case "D": deltaY = 1
                case "L": deltaX = -1
                case "R": deltaX = 1
                default: fatalError("Invalid input")
                }
                if (0..<digits.count ~= current.y + deltaY ) {
                    let keypadRow = digits[current.y + deltaY]
                    if 0..<keypadRow.count ~= current.x + deltaX, keypadRow[current.x + deltaX] != nil {
                        current = Position2D(x: current.x + deltaX, y: current.y + deltaY)
                    }
                }
            }
            print("found \(digits[current.y][current.x])")
            result.append(digits[current.y][current.x]!)
        }
        print(result.reduce("", +))
    }
}
