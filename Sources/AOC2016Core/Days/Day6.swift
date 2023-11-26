import Foundation

class Day6: Day {
    var day: Int { 6 }
    let input: [[Character]]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
"""
        } else {
            inputString = try InputGetter.getInput(for: 6, part: .first)
        }
        self.input = inputString
            .split(separator: "\n")
            .map { Array($0) }
    }

    func runPart1() throws {
        let result = decode(using: { $0.value < $1.value })
        print(result)
    }

    func runPart2() throws {
        let result = decode(using: { $0.value > $1.value })
        print(result)
    }

    func decode(using comparator: ((key: Character, value: Int), (key: Character, value: Int)) -> Bool) -> String {
        var buckets = Array(repeating: [Character:Int](), count: input[0].count)
        for i in 0..<buckets.count {
            for row in input {
                buckets[i][row[i], default: 0] += 1
            }
        }
        return buckets.map { dict in
            let max = dict.max(by: comparator)!
            return String(max.key)
        }.joined()
    }
}
