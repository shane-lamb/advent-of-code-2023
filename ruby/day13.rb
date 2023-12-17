def run_part_1(file_name)
  grouped_lines = get_grouped_lines(file_name)
  scores = grouped_lines.map do |lines|
    grid = lines.map { |line| line.split("") }
    get_score(grid)
  end
  scores.sum
end

def get_score(grid)
  score = 0
  horizontal_reflection_index = get_reflection_index(grid)
  score += horizontal_reflection_index * 100 if horizontal_reflection_index
  vertical_reflection_index = get_reflection_index(grid.transpose)
  score += vertical_reflection_index if vertical_reflection_index
  score
end

def get_reflection_index(grid)
  (1...grid.length).each do |index|
    left = (index - 1).downto(0)
    right = (index...grid.length)
    mirrored = left.zip(right).all? do |left_index, right_index|
      next true if left_index.nil? || right_index.nil?
      grid[left_index] == grid[right_index]
    end
    return index if mirrored
  end
  nil
end

def run_part_2(file_name)
end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join("\n").split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "13"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 405
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
