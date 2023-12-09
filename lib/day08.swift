import Foundation

func gcd(_ a: Int, _ b: Int) -> Int {
    var (a, b) = (a, b)
    while b != 0 {
        (a, b) = (b, a % b)
    }
    return abs(a)
}

func gcd(_ vector: [Int]) -> Int {
    return vector.reduce(0, gcd)
}

func lcm(a: Int, b: Int) -> Int {
    return (a / gcd(a, b)) * b
}

func lcm(_ vector : [Int]) -> Int {
    return vector.reduce(1, lcm)
}

let input = try String(contentsOf: URL(fileURLWithPath: "../input/day08")).split(separator: "\n")

let directions = input[0].replacingOccurrences(of: "L", with: "0").replacingOccurrences(
  of: "R", with: "1"
).split(separator: "").map { Int($0)! }

let edgesList = input.dropFirst().map({ desc in
  let splitted = desc.split(separator: " = ")
  let source = splitted[0]
  let destinations = splitted[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(
    of: ")", with: ""
  ).split(separator: ", ")

  return (String(source), destinations.map { String($0) })
})

let edges = Dictionary(uniqueKeysWithValues: edgesList)

func pathLength(from: String, to: String) -> Int {
  func pathLengthRec(current: String, lengthSoFar: Int) -> Int {
    if current == to {
      return lengthSoFar
    } else {
      let nextDir = directions[lengthSoFar % directions.count]
      return pathLengthRec(current: edges[current]![nextDir], lengthSoFar: lengthSoFar + 1)
    }
  }

  return pathLengthRec(current: from, lengthSoFar: 0)
}

print(pathLength(from: "AAA", to: "ZZZ"))

func pathLengthAndEnd(from: String) -> (Int, String) {
  let dirLength = directions.count

  func pathLengthAndEndRec(current: String, dirPointer: Int, lengthSoFar: Int) -> (Int, String) {
    let nextDir = directions[dirPointer]
    let next = edges[current]![nextDir]

    if current.last == "Z" {
      return (lengthSoFar, current)
    } else {
      return pathLengthAndEndRec(current: next, dirPointer: (dirPointer + 1) % dirLength, lengthSoFar: lengthSoFar + 1)
    }
  }

  return pathLengthAndEndRec(current: from, dirPointer: 0, lengthSoFar: 0)
}


let starting = edges.keys.filter { $0.last == "A" }
let toCheckCycles = starting.map { ($0, pathLengthAndEnd(from: $0)) }

//Check for cycles
assert(toCheckCycles.allSatisfy { (edges[$0.0]![0] ==  edges[$0.1.1]![($0.1.0 + 1) % directions.count]) })
let pathLenghts = starting.map { pathLengthAndEnd(from: $0) }.map { $0.0 }

print(lcm(pathLenghts))

