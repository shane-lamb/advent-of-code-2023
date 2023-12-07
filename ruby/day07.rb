def run_part_1(file_name)
  lines = get_lines(file_name)
  hands = parse_hands(lines).sort_by { |hand| get_hand_value(hand) }
  winnings = hands.map.with_index do |hand, index|
    rank = index + 1
    bid = hand[:bid]
    rank * bid
  end
  winnings.sum
end

def get_hand_value(hand, joker_mod = false)
  card_values = hand[:card_values]
  suffix = card_values.join
  nums_of_a_kind = get_nums_of_a_kind(card_values)
  num_wildcards = if joker_mod
                    card_values.count("01")
                  else
                    0
                  end
  return "7" + suffix if fits_shape(nums_of_a_kind, num_wildcards, [5]) # 5 kind
  return "6" + suffix if fits_shape(nums_of_a_kind, num_wildcards, [4]) # 4 kind
  return "5" + suffix if fits_shape(nums_of_a_kind, num_wildcards, [3, 2]) # full house
  return "4" + suffix if fits_shape(nums_of_a_kind, num_wildcards, [3]) # 3 kind
  return "3" + suffix if fits_shape(nums_of_a_kind, num_wildcards, [2, 2]) # 2 pair
  return "2" + suffix if fits_shape(nums_of_a_kind, num_wildcards, [2]) # 1 pair
  "1" + suffix # high card
end

def fits_shape(nums_of_a_kind, num_wildcards, required_nums)
  deficit = 0
  required_nums.each.with_index do |required, index|
    actual = nums_of_a_kind[index]
    actual = 0 if actual.nil?
    deficit += required - actual if actual < required
  end
  deficit <= num_wildcards
end

def get_nums_of_a_kind(card_values)
  card_values
    .filter { |card_value| card_value != "01" } # exclude joker so it can't be counted twice in the "fitting" test
    .group_by { |card_value| card_value }.values.map(&:count)
    .sort.reverse
end

def parse_hands(lines, joker_mod = false)
  card_to_value = {
    "2" => "02",
    "3" => "03",
    "4" => "04",
    "5" => "05",
    "6" => "06",
    "7" => "07",
    "8" => "08",
    "9" => "09",
    "T" => "10",
    "J" => if joker_mod
             "01"
           else
             "11"
           end,
    "Q" => "12",
    "K" => "13",
    "A" => "14",
  }
  lines.map do |line|
    cards, bid = line.split(" ")
    { bid: bid.to_i, card_values: cards.split("").map { |c| card_to_value[c] } }
  end
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  hands = parse_hands(lines, true).sort_by { |hand| get_hand_value(hand, true) }
  winnings = hands.map.with_index do |hand, index|
    rank = index + 1
    bid = hand[:bid]
    rank * bid
  end
  winnings.sum
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "07"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 6440
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 5905
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
