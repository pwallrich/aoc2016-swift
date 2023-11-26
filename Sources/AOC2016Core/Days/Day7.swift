import Foundation
import RegexBuilder

class Day7: Day {
    var day: Int { 7 }
    let input: [Substring]

    let regex = Regex {
        Capture {
            OneOrMore(.word)
        }
        "["
        Capture {
            OneOrMore(.word)
        }
        "]"
        Capture {
            OneOrMore(.word)
        }
    }

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
//            inputString = """
//abba[mnop]qrst
//abcd[bddb]xyyx
//aaaa[qwer]tyui
//ioxxoj[asdfgh]zxcvbn
//baaaa[x]y
//babba[xaba
//"""
            inputString = """
aba[bab]xyz
xyx[xyx]xyx
aaa[kek]eke
zazbz[bzb]cdb
baba[xbab
"""
        } else {
            inputString = try InputGetter.getInput(for: 7, part: .first)
        }
        self.input = inputString
            .split(separator: "\n")
    }

    func runPart1() throws {
        var res = 0
        outer:
        for row in input {
            var hasSequenceInIp = false
            var idx = row.startIndex
            while idx < row.endIndex {
                guard
                    let openBracket = row[idx...].firstIndex(of: "["),
                    let closeBracket = row[openBracket...].firstIndex(of: "]")
                else {
                    hasSequenceInIp = hasSequenceInIp || row[idx...].containsSequence()
                    idx = row.endIndex
                    continue
                }
                if row[openBracket...closeBracket].containsSequence() {
                    continue outer
                }
                hasSequenceInIp = hasSequenceInIp || row[idx...openBracket].containsSequence()
                idx = row.index(after: closeBracket)
            }
            if hasSequenceInIp {
                res += 1
            }
        }
        print(res)
    }

    func runPart2() throws {
        var res = 0
        outer:
        for row in input {
            var abaSequences: [Substring] = []
            var babSequences: [Substring] = []
            var idx = row.startIndex
            while idx < row.endIndex {
                guard let openBracket = row[idx...].firstIndex(of: "[") else {
                    abaSequences.append(contentsOf: row[idx...].getThreeLetterSequences())
                    idx = row.endIndex
                    continue
                }
                guard let closeBracket = row[openBracket...].firstIndex(of: "]") else {
                    abaSequences.append(contentsOf: row[idx..<openBracket].getThreeLetterSequences())
                    babSequences.append(contentsOf: row[openBracket...].getThreeLetterSequences())
                    idx = row.endIndex
                    continue
                }
                babSequences.append(contentsOf: row[openBracket...closeBracket].getThreeLetterSequences())
                abaSequences.append(contentsOf: row[idx..<openBracket].getThreeLetterSequences())

                idx = row.index(after: closeBracket)
            }
            for abaSequence in abaSequences {
                let array = Array(abaSequence)
                if babSequences.contains("\(array[1])\(array[0])\(array[1])") {
                    res += 1
                    break
                }
            }
        }
        print(res)
    }
}

private extension Substring {
    func containsSequence() -> Bool {
        for items in self.windows(ofCount: 4) {
            let idx = items.startIndex
            guard items[idx] == items[items.index(items.startIndex, offsetBy: 3)] else {
                continue
            }
            guard items[items.index(after: idx)] == items[items.index(items.startIndex, offsetBy: 2)] else {
                continue
            }
            guard items[idx] != items[items.index(after: idx)] else {
                continue
            }
            return true
        }
        return false
    }

    func getThreeLetterSequences() -> [Substring] {
        var sequences: [Substring] = []
        for items in self.windows(ofCount: 3) {
            let idx = items.startIndex
            guard items[idx] == items[items.index(items.startIndex, offsetBy: 2)] else {
                continue
            }
            guard items[idx] != items[items.index(after: idx)] else {
                continue
            }
            sequences.append(items)
        }
        return sequences
    }
}
