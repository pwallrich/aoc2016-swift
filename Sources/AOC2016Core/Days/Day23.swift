import Foundation

class Day23: Day {
    var day: Int { 23 }
    let instructions: [Instruction]

    struct State {
        var values: [Substring: Int]
        var ip: Int
        var instructions: [Instruction]

        mutating func copy(arguments: [Substring]) {
            let value = Int(arguments[1]) ?? values[arguments[1]]!
            values[arguments[2]] = value
            ip += 1
        }
        
        mutating func inc(arguments: [Substring]) {
            values[arguments[1]]! += 1
            ip += 1
        }
        mutating func dec(arguments: [Substring]) {
            values[arguments[1]]! -= 1
            ip += 1
        }

        mutating func jnz(arguments: [Substring]) {
            let value = Int(arguments[1]) ?? values[arguments[1]]!
            guard value != 0 else {
                ip += 1
                return
            }
            let inc = Int(arguments[2]) ?? values[arguments[2]]!
            if inc == 0 {
                ip += 1
            } else {
                ip += inc
            }
        }

        mutating func tgl(arguments: [Substring]) {
            let value = values[arguments[1]]!
            guard ip + value < instructions.count else {
                print("invalid tgl")
                ip += 1
                return
            }
            let old = instructions[ip + value]
            switch old.name {
            case "cpy":
                instructions[ip + value] = Instruction(name: "jnz", arguments: old.arguments)
            case "inc":
                instructions[ip + value] = Instruction(name: "dec", arguments: old.arguments)
            case "dec":
                instructions[ip + value] = Instruction(name: "inc", arguments: old.arguments)
            case "jnz":
                instructions[ip + value] = Instruction(name: "cpy", arguments: old.arguments)
            case "tgl":
                instructions[ip + value] = Instruction(name: "inc", arguments: old.arguments)
            default:
                fatalError()
            }
            ip += 1
        }
    }

    struct Instruction {
        let name: String
        let arguments: [Substring]
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
"""
        } else {
            inputString = try InputGetter.getInput(for: 23, part: .first)
        }
        var instructions: [Instruction] = []
        for row in inputString.split(separator: "\n") {
            let words = row.split(separator: " ")
            let instruction: Instruction
            switch words[0] {
            case "cpy":
                instruction = Instruction(name: "cpy", arguments: words)
            case "inc":
                instruction = Instruction(name: "inc", arguments: words)

            case "dec":
                instruction = Instruction(name: "dec", arguments: words)
            case "jnz":
                instruction = Instruction(name: "jnz", arguments: words)
            case "tgl":
                instruction = Instruction(name: "tgl", arguments: words)
            default:
                fatalError()
            }
            instructions.append(instruction)
        }
        self.instructions = instructions
    }

    func runPart1() throws {
        var state = State(values: ["a": 19958400, "b": 4, "c":8, "d": 0], ip: 0, instructions: instructions)
        while state.ip < instructions.count {
            let instruction = state.instructions[state.ip]
            print(instruction, state.values)
            switch instruction.name {
            case "cpy":
                state.copy(arguments: instruction.arguments)
            case "inc":
                state.inc(arguments: instruction.arguments)
            case "dec":
                state.dec(arguments: instruction.arguments)
            case "jnz":
                state.jnz(arguments: instruction.arguments)
            case "tgl":
                state.tgl(arguments: instruction.arguments)
            default:
                fatalError()
            }
        }
        print(state.values["a"]!)
    }
    
    func runPart2() throws {
        var (a, b, c, d) = (12,11,0,0)
        for _ in 0..<10 {
            a = a * b
            b -= 1
        }
        a += 90 * 89
        print(a)
    }
}
