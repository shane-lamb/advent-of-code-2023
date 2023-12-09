def run_part_1(file_name)
  lines = get_lines(file_name)
  sequences = get_sequences(lines)
  sequences.sum { |sequence| predict_next_value_in_sequence(sequence) }
end

def get_sequences(lines)
  lines.map { |line| line.split(" ").map(&:to_i) }
end

def predict_next_value_in_sequence(sequence)
  pairs = sequence.each_cons(2).to_a
  diff_sequence = pairs.map { |a, b| b - a }
  all_zeros = diff_sequence.all? { |diff| diff == 0 }
  return sequence.last if all_zeros
  sequence.last + predict_next_value_in_sequence(diff_sequence)
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  sequences = get_sequences(lines).map { |sequence| sequence.reverse }
  sequences.sum { |sequence| predict_next_value_in_sequence(sequence) }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "09"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 114
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 2
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
