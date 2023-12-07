def run_part_1(file_name)
  lines = get_lines(file_name)
  races = parse_races(lines)
  race_win_condition_counts = races.map do |race|
    distance_to_beat = race[:distance_to_beat]
    race_time = race[:race_time]
    (1...race_time).count { |charge_time| get_distance_travelled(race_time, charge_time) > distance_to_beat }
  end
  race_win_condition_counts.reduce(1) { |possibilities, win_count| possibilities * win_count }
end

def parse_races(lines)
  rows_of_numbers = lines.map { |line| line.split(" ")[1..].map(&:to_i) }
  rows_of_numbers[0].zip(rows_of_numbers[1]).map { |time, distance| { race_time: time, distance_to_beat: distance } }
end

def get_distance_travelled(race_time, charge_time)
  (race_time - charge_time) * charge_time
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  race_time, distance_to_beat = lines.map { |line| line.split(" ")[1..].join.to_i }
  # Brute forcing it as it only takes a few seconds to compute, but could be a lot more efficient.
  # Could calculate the min and max charge times needed to win, and then the number of possible win scenarios
  # would simply be the difference (max - min).
  (1...race_time).count { |charge_time| get_distance_travelled(race_time, charge_time) > distance_to_beat }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "06"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 288
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 71503
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
