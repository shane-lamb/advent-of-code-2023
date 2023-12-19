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

class Tile
  attr_reader :symbol, :pos
  attr_accessor :energised

  def initialize(symbol, pos)
    reflections_by_symbol = {
      "/" => {
        $up => [$right],
        $down => [$left],
        $left => [$down],
        $right => [$up],
      },
      "\\" => {
        $up => [$left],
        $down => [$right],
        $left => [$up],
        $right => [$down],
      },
      "-" => {
        $up => [$left, $right],
        $down => [$left, $right],
        $left => [$left],
        $right => [$right],
      },
      "|" => {
        $up => [$up],
        $down => [$down],
        $left => [$up, $down],
        $right => [$up, $down],
      },
      "." => {
        $up => [$up],
        $down => [$down],
        $left => [$left],
        $right => [$right],
      }
    }

    @symbol = symbol
    @pos = pos
    @energised = false
    @reflections = reflections_by_symbol[symbol]
    @previously_given_reflections = {}
  end

  def get_reflections(direction)
    return [] if @previously_given_reflections[direction]
    @previously_given_reflections[direction] = true
    @reflections[direction]
  end
end

class Map
  include Enumerable
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(height) { Array.new(width) }
  end

  def self.from_lines(lines)
    map = Map.new(lines.first.length, lines.count)
    lines.each.with_index do |line, row|
      line.chars.each.with_index do |char, col|
        pos = Pos.new(col, row)
        tile = Tile.new(char, pos)
        map.add_tile(tile)
      end
    end
    map
  end

  def each
    @tiles.each do |line|
      line.each do |tile|
        yield tile
      end
    end
  end

  def out_of_bounds?(pos)
    pos.x < 0 || pos.x >= @width || pos.y < 0 || pos.y >= @height
  end

  def add_tile(tile)
    @tiles[tile.pos.y][tile.pos.x] = tile
  end

  def get(pos)
    @tiles[pos.y][pos.x]
  end

  def debug_output(beams)
    beam_pos = beams.map { |beam| beam.first }
    @tiles.map do |line|
      line.map do |tile|
        # beam_head = beam_pos.include?(tile.pos)
        # next "X" if beam_head
        tile.energised ? "*" : tile.symbol
      end.join("")
    end
  end
end

def run_part_1(file_name)
  lines = get_lines(file_name)
  map = Map.from_lines(lines)
  run_beam(map)
  energised_count = map.filter { |tile| tile.energised }.count
  energised_count
end

def run_beam(map)
  beams = [[Pos.new(0, 0), $right]]
  while beams.any?
    beams = beams.flat_map do |beam|
      pos, dir = beam
      next [] if map.out_of_bounds?(pos)
      tile = map.get(pos)
      tile.energised = true
      reflections = tile.get_reflections(dir).map { |new_dir| [pos + new_dir, new_dir] }
      reflections
    end
  end
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

day_num = "16"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 46
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
