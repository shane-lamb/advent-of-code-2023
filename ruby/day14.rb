def run_part_1(file_name)
  lines = get_lines(file_name)
  grid = lines.map { |line| line.split("") }
  tilted = grid.transpose.map { |col| roll_rocks(col) }.transpose
  get_total_load(tilted)
end

def roll_rocks(line)
  new_line = line.reduce("") do |rolled_line, char|
    if char == "O" and rolled_line[-1] == "."
      space = rolled_line.reverse.chars.take_while { |c| c == "." }.join
      next rolled_line[0...-space.length] + "O" + space
    end
    rolled_line + char
  end
  new_line.split("")
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  grid = lines.map { |line| line.split("") }
  grid = do_cycles(grid, 1000000000)
  get_total_load(grid)
end

def get_total_load(grid)
  grid.transpose.sum do |col|
    col.reverse.map.with_index do |char, index|
      char == "O" ? index + 1 : 0
    end.sum
  end
end

def do_cycles(grid, target_count)
  cache = {}
  count = 0
  while count < target_count
    cached = cache[grid]
    count += 1
    if cached.nil?
      prev_grid = grid
      grid = do_cycle(grid)
      cache[prev_grid] = grid
    else
      break
    end
  end

  cache_size = cache.keys.size
  start_index = cache.keys.index(grid)
  loop_size = cache_size - start_index
  remaining = target_count - count
  final_index = start_index + (remaining % loop_size)
  grid = cache.values[final_index]
  grid
end

def do_cycle(grid)
  tilted = grid.transpose.map { |col| roll_rocks(col) }
  tilted = tilted.transpose.map { |row| roll_rocks(row) }
  tilted = tilted.transpose.map { |col| roll_rocks(col.reverse).reverse }
  tilted = tilted.transpose.map { |row| roll_rocks(row.reverse).reverse }
  tilted
end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join("\n").split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "14"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 136
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 64
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
