def run_part_1(file_name)
  lines = get_lines(file_name)
  calibration_values = lines.map { |line| get_calibration_value_simple(line) }
  calibration_values.sum
end

def get_calibration_value_simple(line)
  number_chars = line.chars.filter { |char| char =~ /[0-9]/ }
  (number_chars.first + number_chars.last).to_i
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  calibration_values = lines.map { |line| get_calibration_value_advanced(line) }
  calibration_values.sum
end

def get_calibration_value_advanced(line)
  word_to_number_char = {
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }
  number_chars = []
  line.chars.each.with_index do |char, index|
    number_chars.push(char) if char =~ /[0-9]/
    word_to_number_char.keys.each do |word|
      number_chars.push(word_to_number_char[word]) if line[index, word.length] == word
    end
  end
  (number_chars.first + number_chars.last).to_i
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "01"

part_1_test_result = run_part_1("day#{day_num}_test_part_1.txt")
part_1_expected_test_result = 142
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test_part_2.txt")
part_2_expected_test_result = 281
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
