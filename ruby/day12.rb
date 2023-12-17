class DamageRow
  def initialize(line, repeat = 1)
    symbols, numbers_text = line.split(" ")
    @contiguous_damaged = numbers_text.split(",").map(&:to_i) * repeat
    symbols_repeated = ((symbols + "?") * repeat)[0...-1]
    @sequence = symbols_repeated.split("")
  end

  def count_recursive(remaining_sequence, remaining_damaged, lookup)
    cached = lookup[[remaining_sequence.count, remaining_damaged.count]]
    return cached if cached
    damage_count = remaining_damaged.first
    if damage_count.nil?
      return 0 if remaining_sequence.any? { |symbol| symbol == "#" }
      return 1
    end
    next_index = 0
    possibility_count = 0
    while next_index + damage_count <= remaining_sequence.count
      current_index = next_index
      next_index += 1
      leading = remaining_sequence[0...current_index]
      break if leading.any? { |symbol| symbol == "#" }
      chunk = remaining_sequence[current_index...(current_index + damage_count)]
      next if chunk.any? { |symbol| symbol == "." }
      if current_index + damage_count < remaining_sequence.count
        trailing = remaining_sequence[current_index + damage_count]
        next if trailing == "#"
        possibility_count += count_recursive(remaining_sequence[(current_index + damage_count + 1)..-1], remaining_damaged[1..-1], lookup)
      else
        possibility_count += count_recursive(remaining_sequence[(current_index + damage_count)..-1], remaining_damaged[1..-1], lookup)
      end
    end
    lookup[[remaining_sequence.count, remaining_damaged.count]] = possibility_count
    possibility_count
  end

  def count_possible_configurations
    lookup = {}
    count_recursive(@sequence, @contiguous_damaged, lookup)
  end

  def to_s
    @sequence.join("") + " " + @contiguous_damaged.join(",")
  end
end

def run_part_1(file_name)
  lines = get_lines(file_name)
  damage_rows = lines.map { |line| DamageRow.new(line) }
  damage_rows.sum(&:count_possible_configurations)
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  damage_rows = lines.map { |line| DamageRow.new(line, 5) }
  damage_rows.sum(&:count_possible_configurations)
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

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 525152
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
