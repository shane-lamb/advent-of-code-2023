def run_part_1(file_name)
  lines = get_lines(file_name)
  games = lines.map { |line| parse_game_text(line) }
  possible_ids = games.map.with_index do |turns, index|
    impossible = turns.any? { |turn| turn["red"] > 12 || turn["green"] > 13 || turn["blue"] > 14 }
    next index + 1 unless impossible
    0
  end
  possible_ids.sum
end

def parse_game_text(line)
  parts = line.split(/[:;]/)
  turn_texts = parts[1..]
  turn_texts.map { |turn_text| parse_turn_text(turn_text) }
end

def parse_turn_text(turn_text)
  counts = Hash.new(0)
  turn_text.split(",").each do |color_count_text|
    count_text, color_text = color_count_text.strip.split(" ")
    counts[color_text] = count_text.to_i
  end
  counts
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  games = lines.map { |line| parse_game_text(line) }
  fewest_cubes_multiplied = games.map.with_index do |turns, index|
    largest_counts = Hash.new(0)
    turns.each do |turn|
      turn.each_key { |key| largest_counts[key] = [turn[key], largest_counts[key]].max }
    end
    largest_counts.values.reduce(1) { |agg, count| agg * count }
  end
  fewest_cubes_multiplied.sum
end

def get_biggest_turn_cube_count(color, turns)
  turns.max_by { |turn| turn[color] }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "02"

part_1_test_result = run_part_1("day#{day_num}_test_part_1.txt")
part_1_expected_test_result = 8
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test_part_2.txt")
part_2_expected_test_result = 2286
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
