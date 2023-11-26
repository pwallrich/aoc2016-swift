import Foundation
import CryptoKit

class Day14: Day {
    var day: Int { 14 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "abc"
        } else {
            inputString = "zpqevtbw"
        }
        self.input = inputString
    }

    func runPart1() throws {
        var curr = 0
        var keys: [Int] = []
        var foundSequences: [Int: Character] = [:]
        while keys.count < 64 {
            if curr % 100 == 0 {
                print("Iteration \(curr)")
            }
            let computed = Insecure.MD5.hash(data: ("\(input)\(curr)").data(using: .utf8)!)
            let string = computed.map { String(format: "%02hhx", $0) }.joined()
            var found: Character?
            for range in string.windows(ofCount: 3) {
                let set = Set(range)
                if set.count == 1 {
                    found = set.first!
                    break
                }
            }

            guard let found = found else {
                curr += 1
                foundSequences = foundSequences.filter { curr <= $0.key + 1000 }
                continue
            }

            for range in string.windows(ofCount: 5) {
                let set = Set(range)
                if set.count == 1 {
                    for val in foundSequences.filter({ $0.value == set.first! }) {
                        keys.append(val.key)
                        foundSequences[val.key] = nil
                    }
                }
            }

            foundSequences[curr] = found

            curr += 1
            foundSequences = foundSequences.filter { curr <= $0.key + 1000 }
        }

        print(keys.sorted()[63])
        print(curr)
    }

    func runPart2() throws {
        fatalError("Just use the go solution you've build. swift sucks at md5 hashes")

        var curr = 0
        var keys: [Int] = []
        var foundSequences: [Int: Character] = [:]
        while keys.count < 64 {
            if curr % 100 == 0 {
                print("Iteration \(curr)")
            }
            var string: String = "\(input)\(curr)"
            for _ in 0..<2017 {
                let computed = Insecure.MD5.hash(data: string.data(using: .utf8)!)
                string = computed.map { String(format: "%02hhx", $0) }.joined()
            }

            var found: Character?
            for range in string.windows(ofCount: 3) {
                let set = Set(range)
                if set.count == 1 {
                    found = set.first!
                    break
                }
            }

            guard let found = found else {
                curr += 1
                foundSequences = foundSequences.filter { curr <= $0.key + 1000 }
                continue
            }

            for range in string.windows(ofCount: 5) {
                let set = Set(range)
                if set.count == 1 {
                    for val in foundSequences.filter({ $0.value == set.first! }) {
                        keys.append(val.key)
                        foundSequences[val.key] = nil
                    }
                }
            }

            foundSequences[curr] = found

            curr += 1
            foundSequences = foundSequences.filter { curr <= $0.key + 1000 }
        }

        print(keys.sorted()[63])
        print(curr)
    }
}
