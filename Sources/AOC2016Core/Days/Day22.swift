import Foundation
import RegexBuilder
import Collections

class Day22: Day {
    var day: Int { 22 }
    let input: String

    let regex = Regex {
        "node-x"
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        // Size
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        // Used
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        // Avail
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    struct Node {
        let size: Int
        let used: Int
        let available: Int
        var isTarget: Bool
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
Filesystem            Size  Used  Avail  Use%
/dev/grid/node-x0-y0   10T    8T     2T   80%
/dev/grid/node-x0-y1   11T    6T     5T   54%
/dev/grid/node-x0-y2   32T   28T     4T   87%
/dev/grid/node-x1-y0    9T    7T     2T   77%
/dev/grid/node-x1-y1    8T    0T     8T    0%
/dev/grid/node-x1-y2   11T    7T     4T   63%
/dev/grid/node-x2-y0   10T    6T     4T   60%
/dev/grid/node-x2-y1    9T    8T     1T   88%
/dev/grid/node-x2-y2    9T    6T     3T   66%
"""
        } else {
            inputString = try InputGetter.getInput(for: 22, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
//        var nodes: [Position2D: Node] = [:]
//        var maxX: Int = .min
//        for match in input.matches(of: regex) {
//            nodes.append(.init(
//                position: .init(x: match.1, y: match.2),
//                size: match.3,
//                used: match.4,
//                available: match.5))
//            if match.2 == 0 {
//                maxX = max(maxX, match.1)
//            }
//        }
//
//        let target = Position2D(x: maxX, y: 0)
////        print(nodes)
//        var count = 0
//        for node in nodes {
//            guard node.used > 0 else {
//                continue
//            }
//            for second in nodes where second.position != node.position {
//                if node.used <= second.available {
//                    count += 1
//                }
//            }
//        }
//        print(count)
    }

    struct State {
        let grid: [Position2D: Node]
        let empty: Position2D
        let target: Position2D
        let moves: [Position2D]
    }

    func runPart2() throws {
        var nodes: [Position2D: Node] = [:]
        var maxX: Int = .min
        var maxY: Int = .min
        var start: Position2D!
        for match in input.matches(of: regex) {
            let position = Position2D(x: match.1, y: match.2)
            let node = Node(
                size: match.3,
                used: match.4,
                available: match.5,
                isTarget: false)
            nodes[position] = node
            maxX = max(maxX, position.x)
            maxY = max(maxY, position.y)
            if node.used == 0 {
                start = position
            }
        }

        nodes[Position2D(x: maxX, y: 0)]?.isTarget = true

        var possibleStates: [Int: [State]] = [
            0: [.init(grid: nodes, empty: start, target: Position2D(x: maxX, y: 0), moves: [])]
        ]

        struct CacheKey: Hashable {
            let empty: Position2D
            let target: Position2D
        }

        var seen: Set<CacheKey> = []

        while true {
            var next: State = {
                let prio = possibleStates.keys.min()!
                let next = possibleStates[prio]!.removeFirst()
                if possibleStates[prio]!.isEmpty {
                    possibleStates[prio] = nil
                }
                print("next with prio \(prio) \(next.moves.count) \(next.empty) \(next.target)", possibleStates.count)
                return next
            }()

            for offset in [Position2D(x: -1, y: 0), Position2D(x: 0, y: 1), Position2D(x: 1, y: 0), Position2D(x: 0, y: -1)] {
                let newPosition = Position2D(x: next.empty.x + offset.x, y: next.empty.y + offset.y)
                guard 0...maxX ~= newPosition.x, 0...maxY ~= newPosition.y else {
                    continue
                }
                if let last = next.moves.last, newPosition.x == last.x && newPosition.y == last.y {
                    continue
                }

                let nextPosition = next.grid[newPosition]!
                let current = next.grid[next.empty]!
                guard nextPosition.used <= current.size else {
                    continue
                }
                var newGrid = next.grid
                newGrid[newPosition] = .init(size: nextPosition.size,
                                             used: 0,
                                             available: nextPosition.available,
                                             isTarget: false)
                newGrid[next.empty] = .init(size: current.size,
                                             used: nextPosition.used,
                                             available: current.size - nextPosition.used,
                                             isTarget: nextPosition.isTarget)

                if newPosition.x == 0 && newPosition.y == 0 && nextPosition.isTarget {
                    print("DONE", next.moves.count)
                    fatalError()
                }
                let newTarget = nextPosition.isTarget ? next.empty : next.target
                let prio = (newTarget.x + newTarget.y) * 10 + abs(newPosition.x - newTarget.x) + abs(newPosition.y - newTarget.y) * 10 + next.moves.count + 1
                if seen.contains(.init(empty: newPosition, target: newTarget)) {
                    continue
                }
                seen.insert(.init(empty: newPosition, target: newTarget))
                possibleStates[prio, default: []].append(State(
                    grid: newGrid,
                    empty: newPosition,
                    target: newTarget,
                    moves: next.moves + [offset]))
            }
        }
    }
}
