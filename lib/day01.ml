open Base

let input = Files.read_lines "input/day01"
let input_with_words_to_digits = input |> List.map ~f:(
  fun line -> line |> String.substr_replace_all ~pattern:"one" ~with_:"one1one"
  |> String.substr_replace_all ~pattern:"two" ~with_:"two2two"
  |> String.substr_replace_all ~pattern:"three" ~with_:"three3three"
  |> String.substr_replace_all ~pattern:"four" ~with_:"four4four"
  |> String.substr_replace_all ~pattern:"five" ~with_:"five5five"
  |> String.substr_replace_all ~pattern:"six" ~with_:"six6six"
  |> String.substr_replace_all ~pattern:"seven" ~with_:"seven7seven"
  |> String.substr_replace_all ~pattern:"eight" ~with_:"eight8eight"
  |> String.substr_replace_all ~pattern:"nine" ~with_:"nine9nine"
)

let calibration_codes lines = 
  let lines_digits = lines |> List.map ~f:(String.to_list) |> List.map ~f:(List.filter ~f:Char.is_digit) in
  lines_digits |> List.map ~f:(
    fun line_digits -> String.of_char_list [List.hd_exn line_digits; List.last_exn line_digits] |> Int.of_string
  ) 

let part_one = input |> calibration_codes |> List.reduce_exn ~f:(+)
let part_two = input_with_words_to_digits |> calibration_codes |> List.reduce_exn ~f:(+)