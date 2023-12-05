def run_part_1(file_name)
  lines = get_lines(file_name)
  parts = lines.join("\n").split("\n\n").map { |section| section.split("\n") }
  seeds = parts[0][0].split(" ")[1..].map(&:to_i)
  almanac = Almanac.new(parts[1..])
  locations = seeds.map { |id| almanac.get_mapped_id(id, 0, 6) }
  locations.min
end

class Almanac
  def initialize(raw_maps)
    @levels = raw_maps.map do |lines|
      ranges = lines[1..].map do |line|
        dest_range_start, src_range_start, range_length = line.split(" ").map(&:to_i)
        {
          start: src_range_start,
          end: src_range_start + range_length - 1,
          offset: dest_range_start - src_range_start
        }
      end
      ranges.sort_by { |range| range[:start] }
    end
  end

  def get_mapped_id(original_id, start_index, end_index)
    (start_index..end_index).reduce(original_id) do |mapped_id, current_index|
      range = get_range(mapped_id, current_index)
      next mapped_id if range == nil
      mapped_id + range[:offset]
    end
  end

  def get_range(id, index)
    level = @levels[index]
    level.each do |range|
      next if range[:start] > id
      next if id > range[:end]
      return range
    end
    nil
  end
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  lines.count
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "05"

part_1_test_result = run_part_1("day#{day_num}_test_part_1.txt")
part_1_expected_test_result = 35
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

# part_2_test_result = run_part_2("day#{day_num}_test_part_2.txt")
# part_2_expected_test_result = 5678
# if part_2_test_result != part_2_expected_test_result
#   puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
# end
#
# part_2_result = run_part_2("day#{day_num}_input.txt")
# puts "part 2 result: #{part_2_result}"
