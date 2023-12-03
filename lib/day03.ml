open Base

let input = Files.read_lines "input/day03"

module IntPair = struct
  module T = struct
    type t = int * int [@@deriving compare, sexp_of, hash]
  end

  include T
  include Comparator.Make (T)
end

type number = { x_start : int; x_end : int; y : int }

let get_next_number line i =
  let rec get_next_number' line i acc =
    match line with
    | hd :: tl when Char.is_digit hd && Option.is_some acc ->
        get_next_number' tl (i + 1) (Some (Option.value_exn acc @ [ hd ]))
    | hd :: tl when Char.is_digit hd && Option.is_none acc ->
        get_next_number' tl (i + 1) (Some [ hd ])
    | _ :: _ as remaining_line when Option.is_some acc ->
        (acc, (remaining_line, i))
    | _ :: tl when Option.is_none acc -> get_next_number' tl (i + 1) None
    | [] -> (acc, ([], i))
    | _ -> failwith "Wrong use of find number"
  in
  get_next_number' line i None

let get_line_numbers line y =
  let rec get_line_numbers' remaining_line i =
    match get_next_number remaining_line i with
    | None, _ -> []
    | Some number, (shorter_line, later_i) ->
        (number, (later_i - 1, y)) :: get_line_numbers' shorter_line later_i
  in
  get_line_numbers' line 0

let parsed_symbols =
  let grid = Hashtbl.create (module IntPair) in
  input
  |> List.iteri ~f:(fun y line ->
         line |> String.to_list
         |> List.iteri ~f:(fun x c ->
                match c with
                | _ when (not (Char.is_digit c)) && not (Char.equal c '.') ->
                    Hashtbl.set grid ~key:(y, x) ~data:c
                | _ -> ()));
  grid

let numbers =
  input |> List.map ~f:String.to_list
  |> List.mapi ~f:(fun y line -> get_line_numbers line y)
  |> List.reduce_exn ~f:( @ )
  |> List.map ~f:(fun (n, (end_x, y)) ->
         (Int.of_string (String.of_char_list n), (end_x, y)))

let is_adjacent (n, (n_end_x, n_y)) (c_y, c_x) =
  c_y >= n_y - 1
  && c_y <= n_y + 1
  && c_x <= n_end_x + 1
  && c_x >= n_end_x - String.length (Int.to_string n)

let part_one =
  numbers
  |> List.filter ~f:(fun number ->
         parsed_symbols
         |> Hashtbl.existsi ~f:(fun ~key:c_coord ~data:_ ->
                is_adjacent number c_coord))
  |> List.map ~f:(fun (n, _) -> n)
  |> List.reduce_exn ~f:( + )

let gears =
  parsed_symbols
  |> Hashtbl.filter ~f:(fun c -> Char.equal c '*')
  |> Hashtbl.filteri ~f:(fun ~key:c_coord ~data:_ ->
         List.length
           (List.filter numbers ~f:(fun number -> is_adjacent number c_coord))
         = 2)

let part_two =
  gears
  |> Hashtbl.mapi ~f:(fun ~key:c_coord ~data:_ ->
         numbers
         |> List.filter ~f:(fun number -> is_adjacent number c_coord)
         |> List.map ~f:(fun (n, _) -> n)
         |> List.reduce_exn ~f:( * ))
  |> Hashtbl.to_alist
  |> List.map ~f:(fun (_, ratio) -> ratio)
  |> List.reduce_exn ~f:( + )
