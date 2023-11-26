import Foundation

class Day21: Day {
    var day: Int { 21 }
    let startString: String
    let instructions: [Substring]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            startString = "a_______"
            inputString = """
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
rotate right 2 step
"""
        } else {
            startString = "abcdefgh"
            inputString = try InputGetter.getInput(for: 21, part: .first)
        }
        self.instructions = inputString.split(separator: "\n")
    }

    func process(input: [Character], instruction: Substring) -> [Character] {
        let words = instruction.split(separator: " ")
        var curr = input
        if instruction.starts(with: "swap position") {
            // swap position X with position Y
            let first = Int(words[2])!
            let second = Int(words[5])!
            curr.swapAt(first, second)
        } else if instruction.starts(with: "swap letter") {
            // swap letter X with letter Y
            let first = curr.firstIndex(of: words[2].first!)!
            let second = curr.firstIndex(of: words[5].first!)!
            curr.swapAt(first, second)
        } else if instruction.starts(with: "rotate left") {
            // rotate left X steps
            let amount = Int(words[2])!
            curr = curr.rotateLeft(amount: amount)

        } else if instruction.starts(with: "rotate right") {
            // rotate right X steps
            let amount = Int(words[2])!
            curr = curr.rotateRight(amount: amount)

        } else if instruction.starts(with: "rotate based on position") {
            // rotate based on position of letter X
            let letter = words.last!.first!
            let idx = curr.firstIndex(of: letter)!
            let amount = 1 + idx + (idx >= 4 ? 1 : 0)
            curr = curr.rotateRight(amount: amount)
        } else if instruction.starts(with: "reverse positions") {
            // reverse positions X through Y
            let start = Int(words[2])!
            let end = Int(words[4])!
            curr.reverse(subrange: start..<(end + 1))
        } else if instruction.starts(with: "move position") {
            // move position X to position Y
            let from = Int(words[2])!
            let to = Int(words[5])!
            let t = curr.remove(at: from)
            curr.insert(t, at: to)
        } else {
            fatalError("Unknown instruction")
        }
        return curr
    }

    func runPart1() throws {
        var curr: [Character] = Array(startString)

        for row in instructions {
            curr = process(input: curr, instruction: row)
            print(String(curr))
        }
        
    }

    func processReverse(input: [Character], instruction: Substring) -> [Character] {
        let rotateLookup = [
            1: 0,
            3: 1,
            5: 2,
            7: 3,
            2: 4,
            4: 5,
            6: 6,
            0: 7
        ]
        var curr = input
        let words = instruction.split(separator: " ")
        if instruction.starts(with: "swap position") {
            // swap position X with position Y
            let first = Int(words[2])!
            let second = Int(words[5])!
            curr.swapAt(second, first)
        } else if instruction.starts(with: "swap letter") {
            // swap letter X with letter Y
            let first = curr.firstIndex(of: words[2].first!)!
            let second = curr.firstIndex(of: words[5].first!)!
            curr.swapAt(second, first)
        } else if instruction.starts(with: "rotate left") {
            // rotate left X steps
            let amount = Int(words[2])!
            curr = curr.rotateRight(amount: amount)

        } else if instruction.starts(with: "rotate right") {
            // rotate right X steps
            let amount = Int(words[2])!
            curr = curr.rotateLeft(amount: amount)

        } else if instruction.starts(with: "rotate based on position") {
            // rotate based on position of letter X
            let letter = words.last!.first!
            let idx = curr.firstIndex(of: letter)!
            let originalIndex = rotateLookup[idx]!
            let diff = originalIndex - idx
            if diff < 0 {
                curr = curr.rotateLeft(amount: -diff)
            } else if diff > 0 {
                curr = curr.rotateRight(amount: diff)
            }

        } else if instruction.starts(with: "reverse positions") {
            // reverse positions X through Y
            let start = Int(words[2])!
            let end = Int(words[4])!
            curr.reverse(subrange: start..<(end + 1))
        } else if instruction.starts(with: "move position") {
            // move position X to position Y
            let from = Int(words[2])!
            let to = Int(words[5])!
            let t = curr.remove(at: to)
            curr.insert(t, at: from)
        } else {
            fatalError("Unknown instruction")
        }

        return curr
    }

    func runPart2() throws {
        var curr: [Character] = Array("fbgdceah")
        for row in instructions.reversed() {
            curr = processReverse(input: curr, instruction: row)
            print(String(curr))
        }
    }
}

fileprivate extension Array where Element == Character {
    func rotateLeft(amount: Int) -> Self {
        // rotate left X steps
        let actuallyShifted = amount % count
        let removed = self[0..<actuallyShifted]
        return  self[actuallyShifted...] + Array(removed)
    }

    func rotateRight(amount: Int) -> Self {
        let actuallyShifted = amount % self.count
        let idx = self.count - actuallyShifted
        return Array(self[(idx)...]) + Array(self[..<idx])
    }
}
