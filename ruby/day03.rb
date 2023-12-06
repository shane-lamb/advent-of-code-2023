def run_part_1(file_name)
  lines = get_lines(file_name)
  parts = get_parts(lines)
  adjacent_to_symbols = parts.filter { |part| part[:symbols].count > 0 }
  adjacent_to_symbols.sum { |part| part[:number] }
end

def get_parts(lines)
  parts = []
  lines.each.with_index do |line, row|
    col = 0
    number_regex = /[0-9]+/
    while true do
      substring = line[col..]
      substring_index = substring.index(number_regex)
      break if substring_index == nil
      number = substring[substring_index..].scan(number_regex).first
      col += substring_index
      symbols = get_adjacent_symbols(row, col, number.length, lines)
      parts.push({ number: number.to_i, symbols: })
      col += number.length
    end
  end
  parts
end

def get_adjacent_symbols(row, col, length, lines)
  row_range = [row - 1, 0].max..[row + 1, lines.count - 1].min
  col_range = [col - 1, 0].max..[col + length, lines[0].length - 1].min
  symbols = []
  row_range.each do |r|
    col_range.each do |c|
      char = lines[r][c]
      is_symbol = char.match? /[^0-9.]/
      symbols.push({ char:, col: c, row: r }) if is_symbol
    end
  end
  symbols
end

def run_part_2(file_name)
  lines = get_lines(file_name)

  parts = get_parts(lines)

  symbols = Hash.new([])
  parts.each do |part|
    part[:symbols].map { |symbol| symbols[symbol] += [part[:number]] }
  end

  gears = symbols.filter { |symbol, numbers| symbol[:char] == "*" && numbers.count > 1 }

  gears.sum do |_, numbers|
    numbers.reduce(1) { |a, b| a * b }
  end
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "03"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 4361
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 467835
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
