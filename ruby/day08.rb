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
  attr_reader :name, :to_z_nodes, :loop_length

  def initialize(line)
    @name, @left_name, @right_name = line.scan(/\w+/)
  end

  def follow_step(step, nodes)
    { "L" => nodes[@left_name], "R" => nodes[@right_name] }[step]
  end

  def post_initialise(steps, nodes)
    return if @name.chars.last != 'A'

    z_nodes = {}
    cursor_node = self
    step_index = 0
    steps_loop_count = 0

    while true
      step = steps[step_index]
      next_node = cursor_node.follow_step(step, nodes)

      if next_node.name.chars.last == 'Z'
        key = next_node.name + step_index.to_s
        travelled = steps_loop_count * steps.length + step_index + 1
        if z_nodes[key]
          @loop_length = travelled
          @to_z_nodes = z_nodes.values
          puts "loop length: #{@loop_length}"
          puts "z_nodes: #{@to_z_nodes}"
          break
        end
        z_nodes[key] = travelled
      end

      cursor_node = next_node
      step_index += 1
      if step_index == steps.length
        steps_loop_count += 1
        step_index = 0
      end
    end
  end
end

def run_part_2(file_name)
  steps_lines, node_lines = get_grouped_lines(file_name)
  nodes = node_lines.map { |line| Node.new(line) }.to_h { |node| [node.name, node] }
  steps = steps_lines.first
  nodes.values.each { |node| node.post_initialise(steps, nodes) }

  a_nodes = nodes.filter { |name| name.chars.last == "A" }.values

  step_count = 0

  while true
    nearest_zs = a_nodes.map do |a_node|
      cursor_index = step_count % a_node.loop_length
      z_distances = a_node.to_z_nodes
                          .map { |to_z_node| to_z_node - cursor_index }
      z_distances_normalised = z_distances.map { |dist| (dist + a_node.loop_length) % a_node.loop_length }
      z_distances_normalised.min
    end

    max_nearest_z = nearest_zs.max
    break if max_nearest_z == 0

    step_count += max_nearest_z
  end
  step_count

  # how to use caching to fix performance? or is a smarter algorithm needed?
  # what could we cache?
  # the steps repeat. therefore, we should end up with a number of cyclical paths, dependent on the starting position.
  # because the path is cyclical, from any given starting point within the path we should be able to cache the distance
  # to each reachable Z node (or the closest reachable) and cache that. along with its name
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
