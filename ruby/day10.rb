class Pos
  attr_reader :x, :y

  # top left corner is (0, 0)
  # x is column index, y is row index
  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Pos.new(@x + other.x, @y + other.y)
  end
  def -(other)
    Pos.new(@x - other.x, @y - other.y)
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def eql?(other)
    self == other
  end

  def hash
    [@x, @y].hash
  end

  def to_s
    "(#{x}, #{y})"
  end
end

$up = Pos.new(0, -1)
$down = Pos.new(0, 1)
$left = Pos.new(-1, 0)
$right = Pos.new(1, 0)
$all_directions = [$up, $down, $left, $right]

$tile_connection_map = {
  "S" => [$up, $down, $left, $right],
  "|" => [$up, $down],
  "-" => [$left, $right],
  "F" => [$down, $right],
  "L" => [$up, $right],
  "7" => [$down, $left],
  "J" => [$up, $left],
}

class Tile
  attr_reader :char, :pos
  attr_accessor :visited, :countable

  def initialize(char, pos, map, countable = true)
    @char = char
    @pos = pos
    @visited = false
    @countable = countable
    @map = map
  end

  def on_border?
    return true if @pos.x == 0 || @pos.y == 0 || @pos.x == @map.width - 1 || @pos.y == @map.height - 1
    false
  end

  def get_neighbours
    unfiltered = $all_directions.map do |offset|
      pos = @pos + offset
      next nil if pos.x < 0 || pos.y < 0
      next nil if pos.x >= @map.width || pos.y >= @map.height
      @map.get(pos)
    end
    unfiltered.filter { |tile| tile != nil }
  end

  def get_connections
    get_neighbours.filter do |tile|
      this_connections = $tile_connection_map[@char]
      other_connections = $tile_connection_map[tile.char]
      next false unless this_connections && other_connections
      this_connects_to_other = this_connections.include?(tile.pos - @pos)
      other_connects_to_this = other_connections.include?(@pos - tile.pos)
      this_connects_to_other && other_connects_to_this
    end
  end
end

class Map
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(height) { Array.new(width) }
  end

  def find(char)
    @tiles.each do |line|
      line.each do |tile|
        return tile if tile.char == char
      end
    end
    nil
  end

  def add_tile(tile)
    @tiles[tile.pos.y][tile.pos.x] = tile
  end

  def get(pos)
    @tiles[pos.y][pos.x]
  end

  def iterate
    @tiles.each do |line|
      line.each do |tile|
        yield tile
      end
    end
  end

  def debug_output
    @tiles.map do |line|
      line.map do |tile|
        if tile.visited
          "*"
        else
          tile.char
        end
      end.join("")
    end
  end
end

def run_part_1(file_name)
  lines = get_lines(file_name)
  map = get_map(lines)
  loop_length = get_loop_tiles(map).count
  loop_length / 2
end

def get_map(lines)
  map = Map.new(lines.first.length, lines.length)
  lines.each.with_index do |line, row|
    line.chars.each.with_index do |char, col|
      pos = Pos.new(col, row)
      tile = Tile.new(char, pos, map)
      map.add_tile(tile)
    end
  end
  map
end

def get_loop_tiles(map)
  start_tile = map.find("S")
  curr_tile = start_tile
  prev_tile = nil
  tiles = []
  while true
    tiles << curr_tile
    next_tile = curr_tile.get_connections.filter { |tile| tile != prev_tile }.first
    break if next_tile == start_tile
    prev_tile = curr_tile
    curr_tile = next_tile
  end
  tiles
end

def clean_map(original_map, loop_tiles)
  map = Map.new(original_map.width, original_map.height)
  original_map.iterate do |tile|
    on_path = loop_tiles.include?(tile)
    copied_tile = Tile.new(on_path ? tile.char : ".", tile.pos, map)
    map.add_tile(copied_tile)
  end
  map
end

def expand_map(original_map)
  map = Map.new(original_map.width * 2, original_map.height * 2)
  original_map.iterate do |tile|
    pos = Pos.new(tile.pos.x * 2, tile.pos.y * 2)
    countable = tile.char == "."
    map.add_tile(Tile.new(tile.char, pos, map, countable))
    connections = tile.get_connections
    right = connections.any? { |t| t.pos.x > tile.pos.x }
    down = connections.any? { |t| t.pos.y > tile.pos.y }
    map.add_tile(Tile.new(right ? "-" : ".", pos + $right, map, false))
    map.add_tile(Tile.new(down ? "|" : ".", pos + $down, map, false))
    map.add_tile(Tile.new(".", pos + $right + $down, map, false))
  end
  map
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  map = get_map(lines)
  loop_tiles = get_loop_tiles(map)
  clean_map = clean_map(map, loop_tiles)
  expanded_map = expand_map(clean_map)
  total = 0
  expanded_map.iterate do |tile|
    total += get_enclosed_area_size(tile)
  end
  total
end

def get_enclosed_area_size(start_tile)
  return 0 if start_tile.char != "."
  unvisited = [start_tile]
  count = 0
  touches_edge = false
  while unvisited.count > 0
    to_visit = unvisited
    unvisited = []
    to_visit.each do |tile|
      next if tile.visited
      tile.visited = true
      count += 1 if tile.countable
      touches_edge = true if tile.on_border?
      neighbours = tile.get_neighbours
      neighbours.each do |neighbour|
        unvisited << neighbour if neighbour.char == "."
      end
    end
  end
  return 0 if touches_edge
  count
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

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 1
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_test_result = run_part_2("day#{day_num}_test_2.txt")
part_2_expected_test_result = 4
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_test_result = run_part_2("day#{day_num}_test_3.txt")
part_2_expected_test_result = 8
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
