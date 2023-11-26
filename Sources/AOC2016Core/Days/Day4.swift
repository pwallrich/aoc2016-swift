import Foundation
import RegexBuilder

class Day4: Day {
    var day: Int { 4 }
    let input: String

    let numberRegex = Regex {
        TryCapture {
            OneOrMore(.digit)
        } transform: { Int($0) }
        "["
        Capture {
            OneOrMore(.word)
        }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]
"""
        } else {
            inputString = try InputGetter.getInput(for: 4, part: .first)
        }
        self.input = inputString
    }

    func checkIfValid(row: Substring) -> (name: String, id: Int)? {
        var charCount: [Character: Int] = [:]
        var name: String = ""
        var idx = row.startIndex
        while !row[idx].isNumber {
            charCount[row[idx], default: 0] += 1
            name.append(row[idx])
            idx = row.index(after: idx)
        }
        charCount["-"] = nil

        let match = row[idx...].firstMatch(of: numberRegex)!
        let id = match.output.1

        let sorted = charCount.sorted { first, second in
            if first.value > second.value { return true }
            if second.value > first.value { return false }
            return first.key.asciiValue! < second.key.asciiValue!
        }.reduce("") { $0 + String($1.key) }

        guard sorted.starts(with: match.output.2) else {
            return nil
        }
        return (name, id)
    }

    func runPart1() throws {
        let rows = input.split(separator: "\n")
        let res = rows
            .compactMap(checkIfValid(row:))
            .map(\.id)
            .reduce(0, +)

        print(res)
    }

    func runPart2() throws {
        let rows = input.split(separator: "\n")
        let valid = rows
            .compactMap(checkIfValid(row:))

        for val in valid {
//            print(val.name)
            let offset = val.id % 26
            let decrypted = val.name
                .toAsciiValues()
                .map { val -> UInt8 in
                    guard val != Character("-").asciiValue else {
                        return Character(" ").asciiValue!
                    }

                    let newVal = val + UInt8(offset)
                    guard newVal <= asciiZ else {
                        return asciiA + (newVal - asciiZ - 1)
                    }
                    return newVal
                }
                .map { Character(UnicodeScalar($0)) }
                .reduce("") { $0 + String($1) }
            if decrypted.contains("north") {
                print(decrypted, val.id)
                break
            }
        }
    }
}

fileprivate let asciiZ = Character("z").asciiValue!
fileprivate let asciiA = Character("a").asciiValue!

extension String {
    func toAsciiValues() -> [UInt8] {
        map { $0.asciiValue! }
    }
}

extension Array where Element == Character {
    func toAsciiValues() -> [UInt8] {
        map { $0.asciiValue! }
    }
}
