import Foundation
import RegexBuilder

fileprivate let part9Regex = Regex {
    "("
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    "x"
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    ")"
}

class Day9: Day {
    var day: Int { 9 }
    let input: String



    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            // inputString = "A(2x2)BCD(2x2)EFG"
//            inputString = "X(8x2)(3x3)ABCY"
            inputString = "(27x12)(20x12)(13x14)(7x10)(1x12)A(27x12)(20x12)(13x14)(7x10)(1x12)A(27x12)(20x12)(13x14)(7x10)(1x12)A(27x12)(20x12)(13x14)(7x10)(1x12)A(27x12)(20x12)(13x14)(7x10)(1x12)A(27x12)(20x12)(13x14)(7x10)(1x12)A"
//            inputString = "(27x12)(20x12)(13x14)(7x10)(1x12)A"
//            inputString = "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
        } else {
            inputString = try InputGetter.getInput(for: 9, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var res = ""
        var idx = input.startIndex
        while let match = input[idx...].firstMatch(of: part9Regex) {
            print(match.1, match.2)
            res.append(contentsOf: input[idx..<match.range.lowerBound])

            let startIndex = match.range.upperBound
            let endIndex = input.index(startIndex, offsetBy: match.output.1)
            let inner = Array(repeating: String(input[startIndex..<endIndex]), count: match.output.2)
            res += inner.joined()

            idx = endIndex
        }
        res.append(String(input[idx...]))
        print(res)
        print(res.count)
    }

    func runPart2() throws {
        var count = 0
        var idx = input.startIndex
        let result = input.inflate()
        print(result)
    }
}


extension String {
    func inflate() -> Int {
        var count = 0
        var idx = startIndex
        while let match = self[idx...].firstMatch(of: part9Regex) {
            count += self[idx..<match.range.lowerBound].count

            let startIndex = match.range.upperBound
            let endIndex = self.index(startIndex, offsetBy: match.output.1)
            let inner = String(self[startIndex..<endIndex])
            // revursively
            let next = inner.inflate()
            count += next * match.output.2
            idx = endIndex
        }
        count += self[idx...].count
        return count
    }
}
