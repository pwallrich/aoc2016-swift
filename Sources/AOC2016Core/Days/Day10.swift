import Foundation
import RegexBuilder

class Day10: Day {
    var day: Int { 10 }
    let input: String
    let valueRegex = Regex {
        "value "
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    let instructionRegex = Regex {
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        Capture {
            ChoiceOf {
                "bot"
                "output"
            }
        }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        OneOrMore(.any, .reluctant)
        Capture {
            ChoiceOf {
                "bot"
                "output"
            }
        }
        OneOrMore(.any, .reluctant)
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
"""
        } else {
            inputString = try InputGetter.getInput(for: 10, part: .first)
        }
        self.input = inputString
    }

    enum Output {
        case bot(Int)
        case output(Int)
    }

    func runPart1() throws {
        var bots: [Int: [Int]] = [:]
        var outputs: [Int: Int] = [:]
        var instructions: [Int: (lowTo: Output, highTo: Output)] = [:]
        for row in input.split(separator: "\n") {
            if let match = row.firstMatch(of: valueRegex) {
                bots[match.output.2, default: []].append(match.output.1)
                assert(bots[match.output.2]!.count <= 2)
                continue
            }

            if let match = row.firstMatch(of: instructionRegex) {
                assert(instructions[match.output.1] == nil)
                let low = match.output.2 == "bot" ? Output.bot(match.output.3) : Output.output(match.output.3)
                let high = match.output.4 == "bot" ? Output.bot(match.output.5) : Output.output(match.output.5)
                instructions[match.output.1] = (low, high)
                continue
            }

            fatalError("Invalid argument")
        }

        print(bots)
        print(instructions)

        while bots.contains(where: { $0.value.count == 2 }) {
            let first = bots.first(where: { $0.value.count == 2 })!
            let sorted = first.value.sorted(by: <)

            let instruction = instructions[first.key]!
            switch instruction.lowTo {
            case let .bot(number):
                bots[number, default: []].append(sorted[0])
                assert(bots[number]!.count <= 2)
                if (bots[number] ?? []).sorted() == [17, 61] {
                    print(number)
                    return
                }
            case let .output(number):
                assert(outputs[number] ==  nil)
                outputs[number] = sorted[0]
            }
            switch instruction.highTo {
            case let .bot(number):
                bots[number, default: []].append(sorted[1])
                assert(bots[number]!.count <= 2)
                if (bots[number] ?? []).sorted() == [17, 61] {
                    print(number)
                    return
                }
            case let .output(number):
                assert(outputs[number] ==  nil)
                outputs[number] = sorted[1]
            }
            bots[first.key] = nil
        }
        print(bots)
        print(outputs)
    }

    func runPart2() throws {
        var bots: [Int: [Int]] = [:]
        var outputs: [Int: Int] = [:]
        var instructions: [Int: (lowTo: Output, highTo: Output)] = [:]
        for row in input.split(separator: "\n") {
            if let match = row.firstMatch(of: valueRegex) {
                bots[match.output.2, default: []].append(match.output.1)
                assert(bots[match.output.2]!.count <= 2)
                continue
            }

            if let match = row.firstMatch(of: instructionRegex) {
                assert(instructions[match.output.1] == nil)
                let low = match.output.2 == "bot" ? Output.bot(match.output.3) : Output.output(match.output.3)
                let high = match.output.4 == "bot" ? Output.bot(match.output.5) : Output.output(match.output.5)
                instructions[match.output.1] = (low, high)
                continue
            }

            fatalError("Invalid argument")
        }

        print(bots)
        print(instructions)

        while bots.contains(where: { $0.value.count == 2 }) {
            let first = bots.first(where: { $0.value.count == 2 })!
            let sorted = first.value.sorted(by: <)

            let instruction = instructions[first.key]!
            switch instruction.lowTo {
            case let .bot(number):
                bots[number, default: []].append(sorted[0])
                assert(bots[number]!.count <= 2)
            case let .output(number):
                assert(outputs[number] ==  nil)
                outputs[number] = sorted[0]
            }
            switch instruction.highTo {
            case let .bot(number):
                bots[number, default: []].append(sorted[1])
                assert(bots[number]!.count <= 2)
            case let .output(number):
                assert(outputs[number] ==  nil)
                outputs[number] = sorted[1]
            }
            bots[first.key] = nil
        }
        print(bots)
        print(outputs)
        print(outputs[0]! * outputs[1]! * outputs[2]!)
    }
}
