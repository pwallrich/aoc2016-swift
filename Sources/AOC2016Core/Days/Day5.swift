import Foundation
import CryptoKit

class Day5: Day {
    var day: Int { 5 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "abc"
        } else {
            inputString = "reyedfim"
        }
        self.input = inputString
    }

    func runPart1() throws {
        var curr = 0
        var password: String = ""
        while password.count <= 8 {
            print("Getting pasword character number \(password.count)")
            var hash = (input + "\(curr)").MD5
            while !hash.starts(with: "00000") {
                curr += 1
                if curr % 10000 == 0 {
                    print("current iteration: \(curr)")
                }
                hash = (input + "\(curr)").MD5
            }
            curr += 1
            password.append(hash.dropFirst(5).first!)
            print(password)
        }
        print(password)
    }

    func runPart2() throws {
        var curr = 0
        var password: [Character] = Array(repeating: "-", count: 8)

        while password.contains("-") {
            if curr % 1_000_000 == 0 {
                print("current iteration: \(curr)")
            }

            let computed = Insecure.MD5.hash(data: ("\(input)\(curr)").data(using: .utf8)!)
            curr += 1
            guard computed.starts(with: [0,0]) else {
                continue
            }
            var it = computed.dropFirst(2).makeIterator()
            let next = it.next()!
            // 16 is 10 in Hex and thus, there are no 5 leading zeros
            guard next < 16 else { continue }
            // 0...7 is the valid indices
            guard next < 8, password[Int(next)] == "-" else { continue }
            let second = it.next()!
            password[Int(next)] = String(format: "%x", second / 16).first!
            print(password)
        }
        print(password)
    }
}

extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
