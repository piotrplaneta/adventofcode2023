import Foundation

let input = try String(contentsOf: URL(fileURLWithPath: "../input/day06")).split(separator: "\n").map { $0.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }[1].split(separator: " ") }

for p in zip(input[0], input[1]) {
    print(p)
}