import Foundation

class Day16: Day {
    var day: Int { 16 }
    let length: Int
    let start: [UInt8]

    init(testInput: Bool) throws {
        if testInput {
            length = 20
            start = "10000".map { UInt8(String($0))! }
        } else {
            length = 35651584
            start = "10010000000110000".map { UInt8(String($0))! }
        }
    }

    func runPart1() throws {

        var curr = start
        while curr.count < length {
            print("next", curr.count)
            var res = curr + [0]
            res += curr.reversed().map { $0 == 0 ? 1 : 0}
            curr = res
        }

        var checksum: [UInt8] = Array(curr[..<length])
        repeat {
            var new: [UInt8] = []
            for i in stride(from: 0, to: checksum.count, by: 2) {
                if checksum[i] == checksum[i + 1] {
                    new.append(1)
                } else {
                    new.append(0)
                }
            }
            print(new.count)

            checksum = new

        } while checksum.count % 2 == 0

        print(checksum.reduce("") { $0 + "\($1)"})
    }

    func runPart2() throws {}
}
