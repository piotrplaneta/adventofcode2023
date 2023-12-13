import Foundation

struct RowAndConditions: Hashable {
  let row: Substring.SubSequence
  let conditions: [Int]
}

var calculatedWays: [RowAndConditions: Int] = [:]

let input = try String(contentsOf: URL(fileURLWithPath: "../input/day12"))
  .split(separator: "\n").map {
    (
      $0.split(separator: " ")[0],
      $0.split(separator: " ")[1].split(separator: ",").map { Int($0)! }
    )
  }

func waysOfPuttingSprings(_ rowAndConditions: (Substring.SubSequence, [Int])) -> Int {
  let row = rowAndConditions.0
  let conditions = rowAndConditions.1

  if calculatedWays.keys.contains(RowAndConditions(row: row, conditions: conditions)) {
    return calculatedWays[RowAndConditions(row: row, conditions: conditions)]!
  } else {
    let calculated = switch (row, conditions) {
    case (_, []) where row.allSatisfy { $0 != "#" }: 1
    case (_, []): 0
    case (_, _) where row.first == ".": waysOfPuttingSprings((row.dropFirst(), conditions))
    case (_, _) where row.first == "#":
      {
        let springsToPut = conditions[0]
        let availableSpace = row.count - row.trimmingPrefix(while: { $0 == "?" || $0 == "#" }).count

        return
        if availableSpace < springsToPut
          || (springsToPut < row.count
            && row[row.index(row.startIndex, offsetBy: springsToPut)] == "#")
        {
          0
        } else {
          waysOfPuttingSprings((row.dropFirst(springsToPut + 1), Array(conditions.dropFirst())))
        }
      }()
    case (_, _) where row.first == "?":
      {
        waysOfPuttingSprings(("#" + row.dropFirst(), conditions))
          + waysOfPuttingSprings((row.dropFirst(), conditions))
      }()
    case (_, _): 0
    }

    calculatedWays[RowAndConditions(row: row, conditions: conditions)] = calculated
    return calculated
  }
}

print(input.map { waysOfPuttingSprings($0) }.reduce(0, +))

let unfoldedInput = input.map { test in
  let row = test.0
  let conditions = test.1

  return (
    Substring.SubSequence([Substring.SubSequence](repeating: row, count: 5).joined(separator: "?")),
    Array([[Int]](repeating: conditions, count: 5).joined())
  )
}

print(unfoldedInput.map { waysOfPuttingSprings($0) }.reduce(0, +))
