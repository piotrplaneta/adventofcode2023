import Foundation

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

func pathLengthGhosts() -> Int64 {
  let starts = edges.keys.filter { $0.last == "A" }
  print(starts)

  func pathLengthRec(currents: [String], lengthSoFar: Int64) -> Int64 {
    print(lengthSoFar)
    if currents.allSatisfy({ $0.last == "Z" }) {
      return lengthSoFar
    } else {
      let nextDir = directions[Int(lengthSoFar % Int64(directions.count))]
      return pathLengthRec(
        currents: currents.map { edges[$0]![nextDir] }, lengthSoFar: lengthSoFar + 1)
    }

  }
  return pathLengthRec(currents: starts, lengthSoFar: 0)
}

print(pathLength(from: "AAA", to: "ZZZ"))

print(pathLengthGhosts())
