import Foundation
import CryptoKit

class Day17: Day {
    var day: Int { 17 }
    let input: String
    let destination = Position2D(x: 3, y: 3)

    init(testInput: Bool) throws {
        if testInput {
            input = "ulqzkmiv"
        } else {
            input = "njfxhljp"
        }
    }

    struct State {
        let path: String
        let current: Position2D
    }

    func runPart1() throws {
        var possibleStates: [State] = [State(path: "", current: Position2D(x: 0, y: 0))]
        var seen: Set<String> = []
        while true {
            // TODO: Optimize
            let currentState = possibleStates.remove(at: 0)
            print(currentState)
            let pathString = input + currentState.path
            let hash = Insecure.MD5.hash(data: pathString.data(using: .utf8)!)
            var it = hash.makeIterator()

            let upDown = it.next()!
            let leftRight = it.next()!

            let newDirections: [(String, Position2D)] = [
                upDown / 16 > 10 ? ("U", Position2D(x: 0, y: -1)) : nil,
                upDown % 16 > 10 ? ("D", Position2D(x: 0, y: 1)) : nil,
                leftRight / 16 > 10 ? ("L", Position2D(x: -1, y: 0)) : nil,
                leftRight % 16 > 10 ? ("R", Position2D(x: 1, y: 0)) : nil,
            ].compactMap { $0 }

            for dir in newDirections {
                let nextState = State(
                    path: currentState.path + dir.0,
                    current: .init(x: currentState.current.x + dir.1.x,
                                   y: currentState.current.y + dir.1.y))
                guard 0..<4 ~= nextState.current.x, 0..<4 ~= nextState.current.y else {
                    continue
                }
                if seen.contains(nextState.path) {
                    continue
                }
                seen.insert(nextState.path)
                if nextState.current == destination {
                    print(nextState)
                    return
                }
                possibleStates.append(nextState)
            }

        }
    }

    func runPart2() throws {
        var possibleStates: [State] = [State(path: "", current: Position2D(x: 0, y: 0))]
        var seen: Set<String> = []
        var solutions: [String] = []
        while let currentState = possibleStates.first {
            // TODO: Optimize
            possibleStates.remove(at: 0)
            print(currentState)
            let pathString = input + currentState.path
            let hash = Insecure.MD5.hash(data: pathString.data(using: .utf8)!)
            var it = hash.makeIterator()

            let upDown = it.next()!
            let leftRight = it.next()!

            let newDirections: [(String, Position2D)] = [
                upDown / 16 > 10 ? ("U", Position2D(x: 0, y: -1)) : nil,
                upDown % 16 > 10 ? ("D", Position2D(x: 0, y: 1)) : nil,
                leftRight / 16 > 10 ? ("L", Position2D(x: -1, y: 0)) : nil,
                leftRight % 16 > 10 ? ("R", Position2D(x: 1, y: 0)) : nil,
            ].compactMap { $0 }

            for dir in newDirections {
                let nextState = State(
                    path: currentState.path + dir.0,
                    current: .init(x: currentState.current.x + dir.1.x,
                                   y: currentState.current.y + dir.1.y))
                guard 0..<4 ~= nextState.current.x, 0..<4 ~= nextState.current.y else {
                    continue
                }
                if seen.contains(nextState.path) {
                    continue
                }
                seen.insert(nextState.path)
                if nextState.current == destination {
                    solutions.append(nextState.path)
                    continue
                }
                possibleStates.append(nextState)
            }
        }
        print(solutions.map(\.count).max())
    }
}
