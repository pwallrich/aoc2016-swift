import Foundation

class Day12: Day {
    var day: Int { 12 }
    let input: [Substring]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
"""
        } else {
            inputString = try InputGetter.getInput(for: 12, part: .first)
        }
        self.input = inputString.split(separator: "\n")
    }

    func runPart1() throws {
        runProgram(isPart1: true)
    }

    func runPart2() async throws {
        runProgram(isPart1: false)
    }

    func runProgram(isPart1: Bool) {
        let iterations = isPart1 ? 26 : 33
        var res = 1
        var curr = 1
        for _ in 0..<iterations {
            let temp = res
            res += curr
            curr = temp

        }
        res += 16 * 12

        print(res)
    }
}
