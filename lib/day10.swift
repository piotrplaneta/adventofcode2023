import Foundation
var grid: [Int: [Int: String]] = [:]

let input = try String(contentsOf: URL(fileURLWithPath: "../input/day10")).split(separator: "\n").map { $0.split(separator: "") }

for (y, line) in input.enumerated() {
  let lineDict = Dictionary(uniqueKeysWithValues: line.enumerated().map { ($0, String($1)) })
  grid[y] = lineDict
}

func validCoords(coords: (Int, Int)) -> Bool {
  let (y, x) = coords

  return x >= 0 && x < grid[0]!.count && y >= 0 && y < grid.count
}

func neighbours(coords: (Int, Int), symbol: String? = nil) -> [(Int, Int)] {
  let (y, x) = coords
  let providedOrGridSymbol = symbol ?? grid[y]![x]!
  let ns: [(Int, Int)] = switch providedOrGridSymbol {
  case "|":
    [(y + 1, x), (y - 1, x)]
  case "-":
    [(y, x - 1), (y, x + 1)]
  case "L":
    [(y - 1, x), (y, x + 1)]
  case "J":
    [(y - 1, x), (y, x - 1)]
  case "7":
    [(y + 1, x), (y, x - 1)]
  case "F":
    [(y + 1, x), (y, x + 1)]
  default:
    []
  }

  return ns.filter { validCoords(coords: $0) }
}

func startCoord() -> (Int, Int) {
  let containingLine = grid.first(where: {
    $0.value.contains(where: {$1 == "S"})
  })!

  let y = containingLine.key
  let x = containingLine.value.first {$1 == "S"}!.key

  return (y, x)
}

func startNeighbours() -> [(Int, Int)] {
  let (startY, startX) = startCoord()
  let validNeighbours = [
    [-1, 0]: ["|", "F", "7"],
    [1, 0]: ["|", "J", "L"],
    [0, -1]: ["-", "F", "L"],
    [0, 1]: ["-", "J", "7"],
  ]

  return validNeighbours.filter({
    validCoords(coords: (startY + $0.key[0], startX + $0.key[1]))
  }).filter { $0.value.contains(grid[startY + $0.key[0]]![startX + $0.key[1]]!) }.map{
    (startY + $0.key[0], startX + $0.key[1])
  }
}

func bfs() -> (Set<[Int]>, Int) {
  var q: [((Int, Int), Int)] = []
  var explored: Set<[Int]> = []

  let root = startCoord()
  explored.insert([root.0, root.1])
  q.append((root, 0))

  var max = -1
  while q.count > 0 {
    let v = q.first!
    q.removeFirst()
    if v.1 > max {
      max = v.1
    }
    
    var ns: [(Int, Int)]
    if v.0 == root {
      ns = startNeighbours()
    } else {
      ns = neighbours(coords: v.0)
    }

    for w in ns {
      if !explored.contains([w.0, w.1]) {
        explored.insert([w.0, w.1])
        q.append((w, v.1 + 1))
      }
    }
  }

  return (explored, max)
}

func maxDistFromStart() -> Int {
  bfs().1
}

print(maxDistFromStart())

func inside(loop: Set<[Int]>, coords: (Int, Int)) -> Bool {
  let (y, endX) = coords
  var countLeft = 0
  var prevYDir = 0

  for x in 0..<endX {
    switch grid[y]![x]! {
      case _ where !loop.contains([y, x]):
        break
      case "|":
        countLeft += 1
      case "L":
        prevYDir = -1
      case "F":
        prevYDir = 1
      case "J" where prevYDir == 1:
        countLeft += 1
        prevYDir = 0
      case "7" where prevYDir == -1:
        countLeft += 1
        prevYDir = 0
      case "S":
        prevYDir = -1
      default:
        break
    }
  }

  return countLeft % 2 == 1
}

func insidePointCount() -> Int {
  let (loop, _) = bfs()

  var count = 0
  for y in 0..<grid.count {
    for x in 0..<grid[0]!.count {
      if !loop.contains([y, x]) && inside(loop: loop, coords: (y, x)) {
        count += 1
      }
    }
  }

  return count
}

print(insidePointCount())