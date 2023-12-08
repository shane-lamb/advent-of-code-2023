def run_part_1(file_name)
  steps_lines, node_lines = get_grouped_lines(file_name)
  nodes = node_lines.map { |line| Node.new(line) }.to_h { |node| [node.name, node] }
  steps = steps_lines.first
  cursor_node = nodes["AAA"]
  step_count = 0
  while cursor_node.name != "ZZZ"
    step = steps[step_count % steps.length]
    cursor_node = cursor_node.follow_step(step, nodes)
    step_count += 1
  end
  step_count
end

class Node
  attr_reader :name, :left_name, :right_name

  def follow_step(step, nodes)
    { "L" => nodes[@left_name], "R" => nodes[@right_name] }[step]
  end

  def initialize(line)
    @name, @left_name, @right_name = line.scan(/\w+/)
  end
end

def run_part_2(file_name)
  steps_lines, node_lines = get_grouped_lines(file_name)
  nodes = node_lines.map { |line| Node.new(line) }.to_h { |node| [node.name, node] }
  steps = steps_lines.first
  cursor_nodes = nodes.filter { |name| name[2] == "A" }.values
  step_count = 0
  while cursor_nodes.any? {|node| node.name[2] != "Z"}
    step = steps[step_count % steps.length]
    cursor_nodes = cursor_nodes.map { |node| node.follow_step(step, nodes) }
    step_count += 1
  end
  step_count
end

def get_grouped_lines(file_name, group_separator = "\n\n")
  get_lines(file_name).join("\n").split(group_separator).map { |group_lines| group_lines.split("\n") }
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "08"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 6
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test_2.txt")
part_2_expected_test_result = 6
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
