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

class Tile
  attr_reader :value, :pos

  def initialize(value, pos)
    @value = value
    @pos = pos
  end
end

class Map
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(height) { Array.new(width) }
  end

  def self.from_char_grid(lines)
    map = Map.new(lines.first.length, lines.length)
    lines.each.with_index do |line, row|
      line.each.with_index do |char, col|
        pos = Pos.new(col, row)
        tile = Tile.new(char, pos)
        map.add_tile(tile)
      end
    end
    map
  end

  def find_all(value)
    tiles = []
    @tiles.each do |line|
      line.each do |tile|
        tiles << tile if tile.value == value
      end
    end
    tiles
  end

  def add_tile(tile)
    @tiles[tile.pos.y][tile.pos.x] = tile
  end

  def get(pos)
    @tiles[pos.y][pos.x]
  end

  def debug_output
    @tiles.map do |line|
      line.map do |tile|
        tile.value
      end.join("")
    end
  end
end

def run_part_1(file_name)
  char_grid = get_lines(file_name).map { |line| line.chars }
  char_grid_expanded = expand_char_grid(char_grid)
  map = Map.from_char_grid(char_grid_expanded)
  tiles = map.find_all("#")
  distances = tiles.map.with_index do |tile, index|
    other_tiles = tiles[index + 1..-1]
    other_tiles.sum do |other_tile|
      diff = tile.pos - other_tile.pos
      diff.x.abs + diff.y.abs
    end
  end
  distances.sum
end

def expand_char_grid(char_grid)
  expand_down = char_grid.flat_map do |row|
    row.all?(".") ? [row, row] : [row]
  end
  expand_left = expand_down.transpose.flat_map do |col|
    col.all?(".") ? [col, col] : [col]
  end
  expand_left.transpose
end

def run_part_2(file_name)
  char_grid = get_lines(file_name).map { |line| line.chars }
  map = Map.from_char_grid(char_grid)
end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join.split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "11"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 374
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

# part_2_test_result = run_part_2("day#{day_num}_test.txt")
# part_2_expected_test_result = 8410
# if part_2_test_result != part_2_expected_test_result
#   puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
# end

# part_2_result = run_part_2("day#{day_num}_input.txt")
# puts "part 2 result: #{part_2_result}"
