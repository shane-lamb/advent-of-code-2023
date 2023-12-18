def run_part_1(file_name)
  line = get_lines(file_name).first
  sequence = line.split(",")
  hashes = sequence.map { |text| get_hash(text) }
  hashes.sum
end

def get_hash(text)
  value = 0
  text.chars.each do |char|
    ascii = get_ascii_code(char)
    value += ascii
    value *= 17
    value = value % 256
  end
  value
end

def get_ascii_code(char)
  char.ord
end

def run_part_2(file_name)
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "15"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 1320
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"
#
# part_2_test_result = run_part_2("day#{day_num}_test.txt")
# part_2_expected_test_result = 5678
# if part_2_test_result != part_2_expected_test_result
#   puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
# end
#
# part_2_result = run_part_2("day#{day_num}_input.txt")
# puts "part 2 result: #{part_2_result}"
