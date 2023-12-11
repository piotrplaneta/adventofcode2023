import Foundation
struct Point: Equatable, Hashable {
  let x: Int
  let y: Int
}

var grid: [Point: String] = [ : ]

let input = try String(contentsOf: URL(fileURLWithPath: "../input/day10")).split(separator: "\n").map { $0.split(separator: "") }

for (y, line) in input.enumerated() {
  for (x, c) in line.enumerated() {
    grid[Point(x: x, y: y)] = String(c)
  }
}

let galaxies = grid.filter { $0.value == "#" }

let emptyRows = (0..<input.count).filter { y in grid.filter({$0.key.y == y}).allSatisfy({$0.value == "."}) }
let emptyCols = (0..<input[0].count).filter { x in grid.filter({$0.key.x == x}).allSatisfy({$0.value == "."}) }

func distancesToOtherGalaxies(start: Point, otherGalaxies: [Point]) -> Int {
  return otherGalaxies.map { dest in
    let startX = min(start.x, dest.x)
    let endX = max(start.x, dest.x)
    let startY = min(start.y, dest.y)
    let endY = max(start.y, dest.y)
    var dist = 0

    for x in startX..<endX {
      if emptyCols.contains(x) {
        dist += 1000000
      } else {
        dist += 1
      }
    }

    for y in startY..<endY {
      if emptyRows.contains(y) {
        dist += 1000000
      } else {
        dist += 1
      }
    }

    return dist
  }.reduce(0, +)
}

let galaxyPoints = Array(galaxies.keys)

var distance = 0
for (i, g1) in galaxyPoints.enumerated() {
  distance += distancesToOtherGalaxies(start: g1, otherGalaxies: Array(galaxyPoints.suffix(from: i + 1)))
}

print(distance)

