def run_part_1(file_name)
  lines = get_lines(file_name)
  map = lines.map { |rows| rows.chars }
  start = find_start(map)
  loop_length = get_loop_length(start, nil, map)
  loop_length / 2
end

def find_start(map)
  map.each.with_index do |line, row|
    line.each.with_index do |tile, col|
      return [row, col] if tile == "S"
    end
  end
end

def get_loop_length(curr_pos, prev_pos, map)
  count = 0
  next_tile = nil
  while next_tile != "S"
    next_tile, next_pos = get_next(curr_pos, prev_pos, map)
    prev_pos = curr_pos
    curr_pos = next_pos
    count += 1
  end
  count
end

def get_next(curr_pos, prev_pos, map)
  offsets = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  tile_connections = {
    "S" => [[-1, 0], [1, 0], [0, -1], [0, 1]],
    "|" => [[-1, 0], [1, 0]],
    "-" => [[0, -1], [0, 1]],
    "F" => [[1, 0], [0, 1]],
    "L" => [[-1, 0], [0, 1]],
    "7" => [[1, 0], [0, -1]],
    "J" => [[-1, 0], [0, -1]],
    "." => []
  }

  curr_tile = map[curr_pos[0]][curr_pos[1]]
  positions = offsets.map do |offset|
    pos = get_dest_pos(curr_pos, offset, map)
    next nil if pos == nil
    next nil if prev_pos == pos

    tile = map[pos[0]][pos[1]]
    curr_accepts_dest = tile_connections[curr_tile].include?(offset)
    negative_offset = offset.map { |num| num * -1 }
    dest_accepts_curr = tile_connections[tile].include?(negative_offset)
    next nil unless curr_accepts_dest && dest_accepts_curr

    [tile, pos]
  end

  dest_tile, dest_pos = positions.filter { |pos| pos != nil }.first
  [dest_tile, dest_pos]
end

def get_dest_pos(start_pos, offset, map)
  start_row, start_col = start_pos
  row_offset, col_offset = offset
  dest_row = start_row + row_offset
  dest_col = start_col + col_offset
  return nil if dest_row >= map.count || dest_row < 0
  return nil if dest_col >= map[0].count || dest_col < 0
  [dest_row, dest_col]
end

def run_part_2(file_name) end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join.split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "10"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 4
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

# part_2_test_result = run_part_2("day#{day_num}_test.txt")
# part_2_expected_test_result = 5678
# if part_2_test_result != part_2_expected_test_result
#   puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
# end
#
# part_2_result = run_part_2("day#{day_num}_input.txt")
# puts "part 2 result: #{part_2_result}"
