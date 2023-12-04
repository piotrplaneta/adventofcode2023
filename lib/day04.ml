open Base

let input = Files.read_lines "input/day04"

let parse card =
  card
  |> String.split_on_chars ~on:[ ':' ]
  |> List.last_exn
  |> String.split_on_chars ~on:[ '|' ]
  |> List.map ~f:(fun part ->
         let numbers = String.split_on_chars ~on:[ ' ' ] (String.strip part) in
         numbers
         |> List.filter ~f:(fun n -> String.length n > 0)
         |> List.map ~f:Int.of_string)
  |> fun pair_list ->
  match pair_list with
  | [ wins; results ] -> (wins, results)
  | _ -> failwith "wrong input"

let parsed_cards = input |> List.map ~f:parse

let matching_card_count (wins, results) =
  results
  |> List.filter ~f:(fun r -> List.exists wins ~f:(fun w -> w = r))
  |> List.length

let card_score card =
  card |> matching_card_count |> fun count ->
  match count with _ when count > 0 -> 2 ** (count - 1) | _ -> 0

let part_one =
  parsed_cards |> List.map ~f:card_score |> List.reduce_exn ~f:( + )

let range_from_1 until =
  let rec range_from_1' current =
    match current with
    | c when c <= until -> c :: range_from_1' (c + 1)
    | _ -> []
  in
  range_from_1' 1

let rec process_subcards cards =
  match cards with
  | current_card :: _ as with_current ->
      (match matching_card_count current_card with
      | 0 -> 0
      | add_n_next ->
          range_from_1 add_n_next
          |> List.map ~f:(fun nth_card ->
                 process_subcards (List.drop with_current nth_card))
          |> List.reduce_exn ~f:( + ))
      |> fun others -> others + 1
  | [] -> 0

let rec process_cards cards =
  match cards with
  | _ :: rest as with_current ->
      process_subcards with_current + process_cards rest
  | [] -> 0

let part_two = process_cards parsed_cards
