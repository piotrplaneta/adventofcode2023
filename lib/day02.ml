open Base

let input = Files.read_lines "input/day02"

let parse_game_line game_line =
  game_line
  |> String.split_on_chars ~on:[ ':' ]
  |> List.last_exn
  |> String.split_on_chars ~on:[ ';'; ',' ]
  |> List.map ~f:(fun draw ->
         let splitted_draw =
           String.split_on_chars ~on:[ ' ' ] (String.strip draw)
         in
         (Int.of_string (List.hd_exn splitted_draw), List.last_exn splitted_draw))

let games_with_index input =
  let rec games_with_index' input index =
    match input with
    | hd :: rest ->
        (index, parse_game_line hd) :: games_with_index' rest (index + 1)
    | [] -> []
  in
  games_with_index' input 1

let games = games_with_index input

let allowed =
  Hashtbl.of_alist_exn
    (module String)
    [ ("red", 12); ("green", 13); ("blue", 14) ]

let allowed_games =
  games
  |> List.filter ~f:(fun (_, game) ->
         List.for_all
           ~f:(fun (n, color) -> Hashtbl.find_exn allowed color >= n)
           game)

let part_one =
  allowed_games
  |> List.map ~f:(fun (game_id, _) -> game_id)
  |> List.reduce_exn ~f:( + )

let min_stones =
  games
  |> List.map ~f:(fun (_, game) ->
         let maxes =
           Hashtbl.of_alist_exn
             (module String)
             [ ("red", 0); ("green", 0); ("blue", 0) ]
         in
         List.iter
           ~f:(fun draw ->
             match draw with
             | n, color ->
                 Hashtbl.change maxes color ~f:(fun maybe_old_n ->
                     Some (Int.max (Option.value_exn maybe_old_n) n)))
           game;
         ( Hashtbl.find_exn maxes "red",
           Hashtbl.find_exn maxes "green",
           Hashtbl.find_exn maxes "blue" ))

let part_two =
  min_stones
  |> List.map ~f:(fun (r, g, b) -> r * g * b)
  |> List.reduce_exn ~f:( + )
