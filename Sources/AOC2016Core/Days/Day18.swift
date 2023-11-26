import Foundation

class Day18: Day {
    var day: Int { 18 }
    let row: [Character]
    let rowCount: Int
    let width: Int

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = ".^^.^.^^^^"
            rowCount = 10
        } else {
            inputString = try InputGetter.getInput(for: 18, part: .first)
            rowCount = 40
        }
        self.row = inputString.map { $0 }
        self.width = inputString.count
    }

    func runPart1() throws {
        var grid: Set<Position2D> = Set(row.enumerated().compactMap { $0.element == "." ? nil : Position2D(x: $0.offset, y: 0) })
        for y in 1..<rowCount {
            for x in 0..<width {
                let isLeftTrap = grid.contains(Position2D(x: x - 1, y: y - 1))
                let isMiddleTrap = grid.contains(Position2D(x: x, y: y - 1))
                let isRightTrap = grid.contains(Position2D(x: x + 1, y: y - 1))

                switch (isLeftTrap, isMiddleTrap, isRightTrap) {
                    case (true, true, false),
                         (false, true, true),
                         (true, false, false),
                         (false, false, true):
                         grid.insert(Position2D(x: x, y: y))
                    default:
                         break
                }
            }
        }
        grid.prettyPrint(width: width, height: rowCount)
        print(grid.count, width * rowCount - grid.count)
    }

    func runPart2() throws {
        let rowCount = 400000
        var grid: Set<Position2D> = Set(row.enumerated().compactMap { $0.element == "." ? nil : Position2D(x: $0.offset, y: 0) })
        for y in 1..<rowCount {
            for x in 0..<width {
                let isLeftTrap = grid.contains(Position2D(x: x - 1, y: y - 1))
                let isMiddleTrap = grid.contains(Position2D(x: x, y: y - 1))
                let isRightTrap = grid.contains(Position2D(x: x + 1, y: y - 1))

                switch (isLeftTrap, isMiddleTrap, isRightTrap) {
                    case (true, true, false),
                         (false, true, true),
                         (true, false, false),
                         (false, false, true):
                         grid.insert(Position2D(x: x, y: y))
                    default:
                         break
                }
            }
        }

        print(grid.count, width * rowCount - grid.count)
    }
}

fileprivate extension Set where Element == Position2D {
    func prettyPrint(width: Int, height: Int) {
        for y in 0..<height {
            for x in 0..<width {
                print(contains(Position2D(x: x, y: y)) ? "^" : ".", terminator: "")
            }
            print()
        }
        print()
    }
}