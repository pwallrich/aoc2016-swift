import Foundation

class Day11: Day {
    var day: Int { 11 }
    let input: [Item]

    struct Item: Equatable, Hashable {
        let element: String
        let isChip: Bool
        var floor: Int
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
    """
        } else {
            inputString = try InputGetter.getInput(for: 11, part: .first)
        }

        var input: [Item] = []

        for (floor, row) in inputString.split(separator: "\n").enumerated() {
            let row = row
                .replacingOccurrences(of: "-compatible", with: "")
                .replacingOccurrences(of: "and a", with: "")
                .replacingOccurrences(of: "and", with: "")
                .replacingOccurrences(of: ", a", with: "")
                .replacingOccurrences(of: ".", with: "")

            let items = row.split(separator: " ").dropFirst(5)
            if (items.first ?? "relevant").starts(with: "relevant")  {
//                input.append(res)
                continue
            }
            for idx in stride(from: items.startIndex, to: items.endIndex, by: 2) {
                let element = String(items[idx])
                let type = String(items[idx + 1])
                input.append(.init(element: element, isChip: type == "microchip", floor: floor))
            }
        }
        self.input = input
        print(self.input)
    }

    struct State {
        let items: [Item]
        let elevator: Int
        let steps: Int

        func generateHash() -> String {
            var res = "\(elevator)"
            var distances: [[Int]] = [[],[],[],[]]
            for item in items.sorted(by: { $0.floor < $1.floor }) where item.isChip {
                let generator = items.first { !$0.isChip && $0.element == item.element }!
                distances[item.floor].append(generator.floor)
            }
            for (floor, values) in distances.enumerated() {
                for value in values.sorted() {
                    res.append("|\(floor)x\(value)")
                }
            }
            return res
        }

        func generateNextStates() -> [State] {
            var res: [State] = []
            let itemsOnElevatorFloor = items.filter { $0.floor == elevator }
            for combination in itemsOnElevatorFloor.combinations(ofCount: 1...2) {
                // elevator going up or down
                for i in [-1, 1] {
                    if (i == 1 && elevator == 3) || (i == -1 && elevator == 0) {
                        continue
                    }
                    var items = items
                    for item in combination {
                        items.removeAll(where: { $0 == item })
                        let newItem = Item(element: item.element, isChip: item.isChip, floor: item.floor + i)
                        items.append(newItem)
                    }
                    guard items.isValid() else {
                        continue
                    }

                    let newState = State(items: items, elevator: elevator + i, steps: steps + 1)
                    res.append(newState)
                }
            }
            return res
        }

        func isFinished() -> Bool {
            for item in items {
                if item.floor != 3 {
                    return false
                }
            }
            return true
        }
    }

    func runPart1() async throws {
        let start = State(items: input, elevator: 0, steps: 0)
        var possibleStates: [State] = [start]
        var seen: Set<String> = [start.generateHash()]
        var steps = 0
        while true {
            print("currently at \(steps) \(possibleStates.count)")
            var next: [State] = []
            for state in possibleStates {
                for nextState in state.generateNextStates() {
                    guard !seen.contains(nextState.generateHash()) else {
//                        print("Cache hit \(nextState.generateHash())")
                        continue
                    }
                    if nextState.isFinished() {
                        print(nextState.steps)
                        return
                    }
                    next.append(nextState)
                    seen.insert(nextState.generateHash())
                }
            }
            possibleStates = next
            steps += 1
        }
    }

    func runPart2() throws {
        let newInput = input + [
            .init(element: "elerium", isChip: false, floor: 0),
            .init(element: "elerium", isChip: true, floor: 0),
            .init(element: "dilithium", isChip: true, floor: 0),
            .init(element: "dilithium", isChip: false, floor: 0)
        ]

        let start = State(items: newInput, elevator: 0, steps: 0)
        var possibleStates: [State] = [start]
        var seen: Set<String> = [start.generateHash()]
        var steps = 0
        while true {
            print("currently at \(steps) \(possibleStates.count)")
            var next: [State] = []
            for state in possibleStates {
                for nextState in state.generateNextStates() {
                    guard !seen.contains(nextState.generateHash()) else {
                        continue
                    }
                    if nextState.isFinished() {
                        print(nextState.steps)
                        return
                    }
                    next.append(nextState)
                    seen.insert(nextState.generateHash())
                }
            }
            possibleStates = next
            steps += 1
        }
    }
}

fileprivate extension Array where Element == Day11.Item {
    func isValid() -> Bool {
        for item in self where item.isChip {
            let generator = self.first { $0.element == item.element && !$0.isChip }!
            guard generator.floor != item.floor else {
                continue
            }
            if self.contains(where: { $0.floor == item.floor && !$0.isChip }) {
                return false
            }
        }
        return true
    }
}
