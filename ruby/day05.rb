def run_part_1(file_name)
  lines = get_lines(file_name)
  parts = lines.join("\n").split("\n\n").map { |section| section.split("\n") }
  seeds = parts[0][0].split(" ")[1..].map(&:to_i)
  almanac = Almanac.new(parts[1..])
  locations = seeds.map { |id| almanac.get_location_id(id)[:id] }
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

  def get_lowest_location_id(start_seed_id, end_seed_id)
    current_seed_id = start_seed_id
    lowest_location_id = nil
    while current_seed_id <= end_seed_id do
      location = get_location_id(current_seed_id)
      min_to_next_range = location[:min_to_next_range]
      id = location[:id]
      lowest_location_id = id if lowest_location_id == nil
      lowest_location_id = [lowest_location_id, id].min
      break if min_to_next_range == nil
      current_seed_id = current_seed_id + min_to_next_range
    end
    lowest_location_id
  end

  def get_location_id(seed_id)
    end_index = @levels.count - 1
    (0..end_index).reduce({ id: seed_id, min_to_next_range: nil }) do |agg, current_index|
      old_id = agg[:id]
      info = get_id_offset(old_id, current_index)
      id = old_id + info[:id_offset]
      min_to_next_range = if agg[:min_to_next_range] == nil
                            info[:to_next_range]
                          elsif info[:to_next_range] == nil
                            agg[:min_to_next_range]
                          else
                            [agg[:min_to_next_range], info[:to_next_range]].min
                          end
      { id:, min_to_next_range: }
    end
  end

  def get_id_offset(id, level_index)
    ranges = @levels[level_index]
    ranges.each do |range|
      next if id > range[:end]
      if range[:start] > id
        return { id_offset: 0, to_next_range: range[:start] - id }
      else
        return { id_offset: range[:offset], to_next_range: (range[:end] + 1) - id }
      end
    end
    { id_offset: 0, to_next_range: nil }
  end
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  parts = lines.join("\n").split("\n\n").map { |section| section.split("\n") }
  seeds = parse_seeds(parts[0][0])
  almanac = Almanac.new(parts[1..])
  lowest_location_ids = seeds.map { |seed| almanac.get_lowest_location_id(seed[:start], seed[:end]) }
  lowest_location_ids.min
end

def parse_seeds(seeds_text)
  values = seeds_text.split(" ")[1..].map(&:to_i)
  seeds = []
  values.each_slice(2) do |pair|
    seeds.push({ start: pair[0], end: pair[0] + pair[1] - 1 })
  end
  seeds
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "05"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 35
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 46
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
