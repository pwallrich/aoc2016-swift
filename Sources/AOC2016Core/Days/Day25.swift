import Foundation

func test(start: Int) {
    // prints value as binary. 282 * 9 has 12 binary digits and thus we need to make sure our input's binary is 101010101010 therefore 2730 - 282 * 9 is the solution
    var (a,b,c,d) = (start,9,0,start)
    d = 282 * 9 + a
    // jnz 1 -21
    while true {
        a = d
        //jnz a -19
        while a != 0 {
            b = a
            a = 0
            outer:
            while true {
                c = 2
                while c != 0 {
                    if b == 0 {
                        break outer
                    }
                    b -= 1
                    c -= 1
                }
                a += 1
            }
            b  = 2
            while c != 0 {
                b -= 1
                c -= 1
            }
            print(b)
        }
    }
}

class Day25: Day {
    var day: Int { 25 }
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
            inputString = try InputGetter.getInput(for: 25, part: .first)
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
            case "out":
                instruction = Instruction(name: "out", arguments: words)
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
        test(start: 2)

        return
        var state = State(values: ["a": 3, "b": 4, "c":8, "d": 0], ip: 0, instructions: instructions)
        while state.ip < instructions.count {
            let instruction = state.instructions[state.ip]
//            print(instruction, state.values)
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
            case "out":
                print(state.values[instruction.arguments[1]]!)
            default:
                fatalError()
            }
        }
        print(state.values["a"]!)
    }

    func runPart2() throws {
    }
}
