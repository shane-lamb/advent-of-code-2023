class DamageRow
  def initialize(line)
    symbols, numbers_text = line.split(" ")
    @contiguous_damaged = numbers_text.split(",").map(&:to_i)
    symbol_map = {
      "#" => "0",
      "." => "1",
    }
    unknown_count = 0
    @sequence = symbols.split("").map do |char|
      if char == "?"
        fetch_index = unknown_count
        unknown_count += 1
        fetch_index
      else
        symbol_map[char]
      end
    end
    @unknown_count = unknown_count
  end

  def generate_possibilities(length)
    (0...2.pow(length)).each do |i|
      yield i.to_s(2).rjust(length, "0").chars
    end
  end

  def count_possible_configurations
    count = 0
    generate_possibilities(@unknown_count) do |possibility|
      to_check = []
      broken_count = 0
      @sequence.each do |symbol|
        resolved = symbol.is_a?(Integer) ? possibility[symbol] : symbol
        if resolved == "0"
          broken_count += 1
        elsif broken_count > 0
          to_check << broken_count
          broken_count = 0
        end
      end
      to_check << broken_count if broken_count > 0
      count += 1 if @contiguous_damaged == to_check
    end
    count
  end
end

def run_part_1(file_name)
  lines = get_lines(file_name)
  damage_rows = lines.map { |line| DamageRow.new(line) }
  damage_rows.sum(&:count_possible_configurations)
end

def run_part_2(file_name)
end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join.split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "12"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 21
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
