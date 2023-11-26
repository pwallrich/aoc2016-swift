import Foundation

class Day24: Day {
    var day: Int { 24 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"""            
        } else {
            inputString = try InputGetter.getInput(for: 24, part: .first)
        }
        self.input = inputString
    }

//    struct State {
//        var seen: Set<Character>
//        var route: [Position2D]
//        var hasFoundInLastStep: Bool
//        var current: Position2D
//    }

    struct State {
        var route: [Node]
        var current: Node
    }

    class Node: Hashable, CustomStringConvertible {


        let name: Character
        var edges: [Node: Int] = [:]

        init(name: Character) {
            self.name = name
        }

        static func ==(lhs: Node, rhs: Node) -> Bool {
            lhs.name == rhs.name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }

        var description: String { String(name) }
    }

//    struct BFSState {
//        let found: Set<Character>
//        let path: [Position2D]
//        let visited: Set<Position2D>
//    }
//
//    func runPart1() throws {
//        var grid: [Position2D: Character] = [:]
//        var toFind: [Node: Position2D] = [:]
//        for (y, row) in input.split(separator: "\n").enumerated() {
//            for (x, char) in row.enumerated() {
//                guard char != "#" else {
//                    continue
//                }
//                let point = Position2D(x: x, y: y)
//                grid[point] = char
//                if char != "." {
//                    let node = Node(name: char)
//                    toFind[node] = point
//                }
//            }
//        }
//
//        var states: [[Position2D]] = [[toFind[.init(name: "0")]!]]
//
//        while true {
//            for state in states {
//                for offset in [(-1, 0), (1, 0), (0, 1), (0, -1)] {
//                    let curr = state.last!
//                    let next = curr.adding(offset)
//                    guard grid[next] != nil else {
//                        continue
//                    }
//                }
//            }
//        }
//
//        for (item, firstPos) in toFind {
//            for (destination, secondPos) in toFind where destination.name != item.name {
//                if let distance = destination.edges[item] {
//                    item.edges[destination] = distance
//                    continue
//                }
//                print("getting distance from \(item.name) to \(destination.name)")
//                guard let distance = grid.findSmallestDistance(from: firstPos, to: secondPos) else {
//                    item.edges[destination] = .max
//                    continue
//                }
//                item.edges[destination] = distance
//                print("got distance from \(item.name) to \(destination.name): \(distance)")
//            }
//        }
//        fatalError()
//    }

    func runPart1() throws {
        var grid: [Position2D: Character] = [:]
        var toFind: [Node: Position2D] = [:]
        var maxX: Int = .min
        var maxY: Int = .min
        for (y, row) in input.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() {
                guard char != "#" else {
                    continue
                }
                let point = Position2D(x: x, y: y)
                grid[point] = char
                if char != "." {
                    let node = Node(name: char)
                    toFind[node] = point
                }
                maxX = max(x, maxX)
            }
            maxY = max(y, maxY)
        }

        for (item, firstPos) in toFind {
            for (destination, secondPos) in toFind where destination.name != item.name {
                if let distance = destination.edges[item] {
                    item.edges[destination] = distance
                    continue
                }
                print("getting distance from \(item.name) to \(destination.name)")
                guard let distance = grid.findSmallestDistance(from: firstPos, to: secondPos) else {
                    item.edges[destination] = .max
                    continue
                }
                item.edges[destination] = distance
                print("got distance from \(item.name) to \(destination.name): \(distance)")
            }
        }

        // bfs
        let start = toFind.keys.first { $0.name == "0" }!
        var possibleRoutes: [([Node], Int)] = [([start], 0)]
        var minDistance: Int = .max
        var it = 0
        while !possibleRoutes.isEmpty {
            print(it, possibleRoutes.count)
            var next: [([Node], Int)] = []
            for route in possibleRoutes {
                if route.0.count == toFind.keys.count {
                    minDistance = min(route.1, minDistance)
                    continue
                }
                for nextDest in route.0.last!.edges {
                    if route.0.contains(nextDest.key) {
                        continue
                    }
                    guard nextDest.1 != .max else {
                        continue
                    }

                    next.append((route.0 + [nextDest.key], route.1 + nextDest.value))
                }
            }
            it += 1
            possibleRoutes = next
        }
        print(minDistance)
        fatalError()
    }

    func runPart2() throws {
        var grid: [Position2D: Character] = [:]
        var toFind: [Node: Position2D] = [:]
        var maxX: Int = .min
        var maxY: Int = .min
        for (y, row) in input.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() {
                guard char != "#" else {
                    continue
                }
                let point = Position2D(x: x, y: y)
                grid[point] = char
                if char != "." {
                    let node = Node(name: char)
                    toFind[node] = point
                }
                maxX = max(x, maxX)
            }
            maxY = max(y, maxY)
        }

        for (item, firstPos) in toFind {
            for (destination, secondPos) in toFind where destination.name != item.name {
                if let distance = destination.edges[item] {
                    item.edges[destination] = distance
                    continue
                }
                print("getting distance from \(item.name) to \(destination.name)")
                guard let distance = grid.findSmallestDistance(from: firstPos, to: secondPos) else {
                    item.edges[destination] = .max
                    continue
                }
                item.edges[destination] = distance
                print("got distance from \(item.name) to \(destination.name): \(distance)")
            }
        }

        // bfs
        let start = toFind.keys.first { $0.name == "0" }!
        var possibleRoutes: [([Node], Int)] = [([start], 0)]
        var minDistance: Int = .max
        var it = 0
        while !possibleRoutes.isEmpty {
            print(it, possibleRoutes.count)
            var next: [([Node], Int)] = []
            for route in possibleRoutes {
                if route.0.count == toFind.keys.count + 1 && route.0.last!.name == "0" {
                    minDistance = min(route.1, minDistance)
                    continue
                }
                for nextDest in route.0.last!.edges {
                    if route.0.contains(nextDest.key) {
                        if route.0.count != toFind.keys.count {
                            continue
                        }
                        if nextDest.key.name != "0" {
                            continue
                        }
                        print("going to end")
                    }
                    guard nextDest.1 != .max else {
                        continue
                    }

                    next.append((route.0 + [nextDest.key], route.1 + nextDest.value))
                }
            }
            it += 1
            possibleRoutes = next
        }
        print(minDistance)
        fatalError()
    }
}

fileprivate extension Dictionary where Key == Position2D, Value == Character {
    struct State {
        let visited: Set<Position2D>
        let route: [Position2D]
        let curr: Position2D
    }
    func findSmallestDistance(from: Position2D, to: Position2D) -> Int? {
        var curr = from
        var visited: Set<Position2D> = [curr]
        var states: [Int: [State]] = [0: [.init(visited: [curr], route: [curr], curr: curr)]]
        while !states.isEmpty {
            let state: State = {
                let prio = states.keys.min()!
                let next = states[prio]!.removeFirst()
                if states[prio]!.isEmpty {
                    states[prio] = nil
                }
                return next
            }()

            for offset in [(-1, 0), (1, 0), (0, 1), (0, -1)] {
                let curr = state.curr
                let next = curr.adding(offset)

                guard self[next] != nil else { continue }
                if next == to {
                    self.prettyPrint(route: state.visited, startPoint: from, endPoint: to)
                    return state.visited.count
                }

                guard !state.visited.contains(next) else { continue }

                guard !visited.contains(next) else { continue }
                visited.insert(next)

                var route = state.visited
                route.insert(next)

                let prio = abs(next.x - to.x) + abs(next.y - to.y) + route.count
                states[prio, default: []].append(.init(visited: route, route: state.route + [next], curr: next))
            }
        }
        return nil
    }

    func prettyPrint(route: Set<Position2D>, startPoint: Position2D, endPoint: Position2D, width: Int = 179, height: Int = 42) {
        for y in 0...height {
            for x in 0...width {
                let pos = Position2D(x: x, y: y)
                let val = self[pos]
                guard let val = val else {
                    if route.contains(pos) {
                        fatalError()
                    }
                    print("🏛️", terminator: "")
                    continue
                }
                if pos == startPoint {
                    print("🚗", terminator: "")
                    continue
                }
                if pos == endPoint {
                    print("🏁", terminator: "")
                    continue
                }
                if route.contains(pos) {
                    print("🔴", terminator: "")
                } else {
                    print(val == "." ? "™️" : "⚽️", terminator: "")
                }
            }
            print()
        }
        print()
    }
}
