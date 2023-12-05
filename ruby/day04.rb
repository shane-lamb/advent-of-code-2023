def run_part_1(file_name)
  lines = get_lines(file_name)
  cards = lines.map { |line| parse_card(line) }
  cards.sum do |card|
    num_matches = get_num_matches(card)
    next 0 if num_matches == 0
    2.pow(num_matches - 1)
  end
end

def get_num_matches(card)
  winning_numbers_owned = card[:numbers_you_have].filter { |num| card[:winning_numbers].include? num }
  winning_numbers_owned.count
end

def parse_card(card_text)
  _, winning_numbers, numbers_you_have = card_text.split(/[:|]/)
  { winning_numbers: parse_numbers(winning_numbers), numbers_you_have: parse_numbers(numbers_you_have) }
end

def parse_numbers(numbers_text)
  numbers_text.strip.split(" ").map(&:to_i)
end

def run_part_2(file_name)
  lines = get_lines(file_name)
  cards = lines.map { |line| parse_card(line) }
  copies_won_cache = {}
  copies_won = (0...cards.count).sum { |index| total_copies_won(cards, index, copies_won_cache) }
  copies_won + cards.count
end

def total_copies_won(cards, index, cache)
  return cache[index] if cache[index]
  direct_copies_won = get_num_matches(cards[index])
  indirect_copies_won = (1..direct_copies_won).sum { |offset| total_copies_won(cards, index + offset, cache) }
  total = direct_copies_won + indirect_copies_won
  cache[index] = total
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "04"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 13
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 30
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
