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
    | _ :: _ when Option.is_some acc -> (acc, i)
    | _ :: tl when Option.is_none acc -> get_next_number' tl (i + 1) None
    | [] -> (acc, i)
    | _ -> failwith "Wrong use of find number"
  in
  get_next_number' line i None

let parse_numbers =
  let numbers = Hashtbl.create (module IntPair) in
  input
  |> List.fold_until ~f:(fun y line -> )

