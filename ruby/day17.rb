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
$none = Pos.new(0, 0)
$all_directions = [$up, $down, $left, $right]

class Tile
  attr_reader :pos, :loss, :distance_left, :is_destination, :connections, :visit_count

  def initialize(char, pos, map)
    @loss = char.to_i
    @distance_left = map.width - pos.x + map.height - pos.y - 2
    @is_destination = @distance_left == 0
    @pos = pos
    @worst_path_loss = (pos.x * 9 + pos.y * 9) * 2
    @best_path_loss = {}
    @visit_count = 0
    @map = map
  end

  def post_initialize()
    @connections = {}
    $all_directions.each do |dir|
      new_pos = @pos + dir
      next if @map.out_of_bounds?(new_pos)
      @connections[dir] = @map.get(new_pos)
    end
  end

  def get_best_path_loss(dir, move_count)
    loss = @best_path_loss[[dir, move_count]]
    return loss unless loss.nil?
    @worst_path_loss
  end

  def register_path_loss(loss, path, max_moves)
    @visit_count += 1
    (path.move_count..max_moves).each do |move_count|
      @best_path_loss[[path.dir, move_count]] = loss
    end
    return unless @is_destination
    if loss < @map.best_path_loss
      @map.best_path_loss = loss
      @map.best_path = path
    end
  end
end

class Map
  include Enumerable
  attr_reader :width, :height, :dest_pos
  attr_accessor :best_path_loss, :best_path

  def initialize(width, height)
    @width = width
    @height = height
    @dest_pos = Pos.new(width - 1, height - 1)
    @tiles = Array.new(height) { Array.new(width) }
    @best_path_loss = (@width + @height - 2) * 9 # worst-case loss
  end

  def self.from_lines(lines)
    map = Map.new(lines.first.length, lines.count)
    lines.each.with_index do |line, row|
      line.chars.each.with_index do |char, col|
        pos = Pos.new(col, row)
        tile = Tile.new(char, pos, map)
        map.add_tile(tile)
      end
    end

    map.each do |tile|
      tile.post_initialize
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

  def debug_output()
    @tiles.map do |line|
      line.map do |tile|
        highlight = @best_path && @best_path.tiles.include?(tile)
        # highlight = tile.visit_count > 0
        highlight ? "-" : tile.loss
        # visit_count = [tile.visit_count, 9].min.to_s
        # "." + tile.visit_count.to_s
      end.join("")
    end
  end
end

class Config
  attr_reader :min_moves, :max_moves

  def initialize(min_moves, max_moves)
    @min_moves = min_moves
    @max_moves = max_moves
  end
end

class Path
  attr_reader :total_loss, :dir, :move_count, :tile, :tiles

  def initialize(config, map, prev_tiles, tile, dir = $down, total_loss = 0, move_count = 0)
    @map = map
    @tile = tile
    @tiles = prev_tiles + [tile]
    @dir = dir
    @total_loss = total_loss
    @move_count = move_count
    @tile.register_path_loss(@total_loss, self, config.max_moves)
    @config = config
  end

  def traverse
    return [] if @tile.is_destination

    map_best = @map.best_path_loss - @tile.distance_left + 1
    @tile.connections.map do |dir, tile|
      next nil if (dir + @dir) == $none # no backtracking
      same_dir = @dir == dir
      next nil if same_dir && @move_count == @config.max_moves
      total_loss = @total_loss + tile.loss
      unless same_dir
        broke = false
        (2..@config.min_moves).each do
          tile = tile.connections[dir]
          if tile.nil?
            broke = true
            break
          end
          total_loss += tile.loss
        end
        next nil if broke
      end
      next nil unless total_loss < tile.get_best_path_loss(dir, @move_count)
      next nil unless total_loss < map_best
      move_count = same_dir ? @move_count + 1 : @config.min_moves
      Path.new(@config, @map, @tiles, tile, dir, total_loss, move_count)
    end.compact
  end
end

def run_part_1(file_name)
  lines = get_lines(file_name)
  map = Map.from_lines(lines)
  config = Config.new(1, 3)
  get_best_path_loss(map, config)
end

def get_best_path_loss(map, config)
  start = map.get(Pos.new(0, 0))
  paths = [Path.new(config, map, [], start)]
  while paths.any?
    first = paths.shift
    first_paths = first.traverse
    paths += first_paths
    paths.sort_by! { |path| path.total_loss + path.tile.distance_left }
  end
  # puts map.debug_output
  map.best_path_loss
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  map = Map.from_lines(lines)
  config = Config.new(4, 10)
  get_best_path_loss(map, config)
end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join("\n").split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "17"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 102
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 94
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
