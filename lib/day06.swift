import Foundation

let input = try String(contentsOf: URL(fileURLWithPath: "../input/day06")).split(separator: "\n").map { $0.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }[1].split(separator: " ").map {Int($0)!} }
let inputPart2 = try String(contentsOf: URL(fileURLWithPath: "../input/day06_part2")).split(separator: "\n").map { $0.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }[1].split(separator: " ").map {Int($0)!} }

func distances(allowedTime: Int) -> [Int] {
    (1..<allowedTime).map { $0*(allowedTime - $0) }
}

func numberOfWays(races: [[Int]]) -> Int {
    zip(races[0], races[1]).map({(tAndD: (Int, Int)) -> Int in
        distances(allowedTime: tAndD.0).filter { $0 > tAndD.1 }.count
    }).reduce(1, *)
}

func lowestCharge(allowedTime: Int, requiredDistance: Int) -> Int {
    (1..<allowedTime).first(where: {$0*(allowedTime - $0) > requiredDistance})!
}

func highestCharge(allowedTime: Int, requiredDistance: Int) -> Int {
    stride(from: allowedTime, to: 0, by: -1).first(where: {$0*(allowedTime - $0) > requiredDistance})!
}

func numberOfWaysFast(races: [[Int]]) -> Int {
    zip(races[0], races[1]).map({(tAndD: (Int, Int)) -> Int in
        let t = tAndD.0
        let d = tAndD.1

        return highestCharge(allowedTime: t, requiredDistance: d) -
            lowestCharge(allowedTime: t, requiredDistance: d) + 1
    }).reduce(1, *)
}

print(numberOfWays(races: input))
print(numberOfWaysFast(races: inputPart2))