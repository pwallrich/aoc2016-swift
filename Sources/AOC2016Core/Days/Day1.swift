//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 01.12.22.
//

import Foundation

class Day1: Day {
    var day: Int { 1 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "R8, R4, R4, R8"
        } else {
            inputString = try InputGetter.getInput(for: 1, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        let instructions = input.split(separator: ", ")
        var x = 0
        var y = 0
        var direction: Direction = .up
        for instruction in instructions {
            switch instruction.first {
            case "R":
                direction = direction.nextClockWise()
            case "L":
                direction = direction.nextCounterClockWise()
            default: break
            }
            let amount = Int(instruction.dropFirst())!
            switch direction {
            case .up: y -= amount
            case .right: x += amount
            case .down: y += amount
            case .left: x -= amount
            }
            print(x, y, direction)
        }
        print(abs(x) + abs(y))
    }

    func runPart2() throws {
        let instructions = input.split(separator: ", ")
        var current = Position2D(x: 0, y: 0)
        var visited: Set<Position2D> = []
        var direction: Direction = .up
        var instructionIdx = instructions.indices.first!
        while true {
            if abs(current.x) == 0 && abs(current.y) == 4 || abs(current.x) == 4 && abs(current.y) == 0 {
                print(current.x)
            }
            visited.insert(current)
            let instruction = instructions[instructionIdx]
            switch instruction.first {
            case "R":
                direction = direction.nextClockWise()
            case "L":
                direction = direction.nextCounterClockWise()
            default: break
            }
            let amount = Int(instruction.dropFirst())!

            var deltaY = 0
            var deltaX = 0
            switch direction {
            case .up: deltaY = 1
            case .right: deltaX = 1
            case .down: deltaY = -1
            case .left: deltaX = -1
            }

            for _ in 0..<amount {
                current = Position2D(x: current.x + deltaX, y: current.y + deltaY)
                if visited.contains(current) {
                    print(abs(current.x) + abs(current.y))
                    return
                }
                visited.insert(current)
            }


            print(instruction, current, direction)
            instructionIdx = (instructionIdx + 1) % instructions.count
        }

    }

    enum Direction {
        case up, right, down, left

        func nextClockWise() -> Direction {
            switch self {
            case .up: return .right
            case .right: return .down
            case .down: return .left
            case .left: return .up 
            }
        }

        func nextCounterClockWise() -> Direction {
            switch self {
            case .up: return .left
            case .right: return .up
            case .down: return .right
            case .left: return .down 
            }
        }
    }
}

struct Position2D: Hashable, Equatable {
    let x: Int
    let y: Int

    func adding(_ other: Position2D) -> Position2D {
        return .init(x: x + other.x, y: y + other.y)
    }

    func adding(_ other: (Int, Int)) -> Position2D {
        return .init(x: x + other.0, y: y + other.1)
    }
}
