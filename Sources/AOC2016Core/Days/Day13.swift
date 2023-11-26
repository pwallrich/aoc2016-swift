import Foundation

class Day13: Day {
    var day: Int { 13 }
    let destination: Position2D
    let secretNumber: Int

    init(testInput: Bool) throws {
        if testInput {
            destination = Position2D(x: 7, y: 4)
            secretNumber = 10
        } else {
            destination = Position2D(x: 31, y: 39)
            secretNumber = 1362
        }
    }

    struct State {
        let point: Position2D
        let steps: Int
    }

    func runPart1() throws {
        let start = Position2D(x: 1, y: 1)
        var nextPossibleStates: [Int: [State]] = [:]
        var next: State = State(point: start, steps: 0)
        var visited: Set<Position2D> = [start]
        while next.point != destination {
            for i in [(-1, 0), (0, -1), (1, 0), (0, 1)] {
                let newPosition = Position2D(x: next.point.x + i.0, y: next.point.y + i.1)
                guard newPosition.x > 0 && newPosition.y > 0 else {
                    continue
                }
                guard !newPosition.isWall(secret: secretNumber), !visited.contains(newPosition) else {
                    continue
                }
                visited.insert(newPosition)
                let distance = abs(destination.x - newPosition.x) + abs(destination.y - newPosition.y)
                nextPossibleStates[distance, default: []].append(.init(point: newPosition, steps: next.steps + 1))
            }
            let smallestDistanceKey = nextPossibleStates.keys.min(by: <)!
            let nextItem = nextPossibleStates[smallestDistanceKey]!.enumerated().min(by: { $0.element.steps < $1.element.steps })!
            nextPossibleStates[smallestDistanceKey]?.remove(at: nextItem.offset)
            if nextPossibleStates[smallestDistanceKey]!.isEmpty {
                nextPossibleStates[smallestDistanceKey] = nil
            }
            next = nextItem.element
        }
        print(next.steps)
    }

    func runPart2() throws {
        let start = Position2D(x: 1, y: 1)
        var nextPossibleStates: [State] = [.init(point: start, steps: 0)]
        var visited: Set<Position2D> = [start]
        var steps = 0
        while steps < 50 {
            print("running step \(steps)")
            var temp: [State] = []
            for next in nextPossibleStates {
                for i in [(-1, 0), (0, -1), (1, 0), (0, 1)] {
                    let newPosition = Position2D(x: next.point.x + i.0, y: next.point.y + i.1)
                    guard newPosition.x >= 0 && newPosition.y >= 0 else {
                        continue
                    }
                    guard !newPosition.isWall(secret: secretNumber), !visited.contains(newPosition) else {
                        continue
                    }
                    visited.insert(newPosition)
                    temp.append(.init(point: newPosition, steps: next.steps + 1))
                }
            }
            nextPossibleStates = temp
            steps += 1
        }
        for nextPossibleState in nextPossibleStates {
            visited.insert(nextPossibleState.point)
        }
        print(visited.count)
    }
}

fileprivate extension Position2D {
    func isWall(secret: Int) -> Bool {
        let number = x*x + 3*x + 2*x*y + y + y*y + secret
        let binary = String(number, radix: 2)
        return binary.filter { $0 == "1" }.count % 2 != 0
    }
}
