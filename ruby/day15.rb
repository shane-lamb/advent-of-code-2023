def run_part_1(file_name)
  line = get_lines(file_name).first
  sequence = line.split(",")
  hashes = sequence.map { |text| get_hash(text) }
  hashes.sum
end

def get_hash(text)
  value = 0
  text.chars.each do |char|
    ascii = get_ascii_code(char)
    value += ascii
    value *= 17
    value = value % 256
  end
  value
end

def get_ascii_code(char)
  char.ord
end

class Instruction
  attr_reader :label, :op, :focal_length, :box_number

  def initialize(text)
    @label, @op, number = text.scan(/([a-z]+)([=-])([0-9]*)/).first
    @box_number = get_hash(@label)
    @focal_length = number.to_i
  end
end

class Box
  def initialize(number)
    @number = number
    @contents = {}
  end

  def run_instruction(instruction)
    if instruction.op == "="
      @contents[instruction.label] = instruction.focal_length
    else
      @contents.delete(instruction.label)
    end
  end

  def get_score
    @contents.sum do |label, focal_length|
      slot_number = @contents.keys.index(label) + 1
      (@number + 1) * slot_number * focal_length
    end
  end
end

class BoxManager
  def initialize()
    @boxes = (0...256).map { |i| Box.new(i) }
  end

  def run_instructions(instructions)
    instructions.each do |instruction|
      box = @boxes[instruction.box_number]
      box.run_instruction(instruction)
    end
  end

  def get_score
    @boxes.sum(&:get_score)
  end
end

def run_part_2(file_name)
  line = get_lines(file_name).first
  sequence = line.split(",")
  instructions = sequence.map { |text| Instruction.new(text) }
  box_manager = BoxManager.new
  box_manager.run_instructions(instructions)
  box_manager.get_score
end

def get_lines(file_name)
  file_path = File.join(__dir__, "..", "data", file_name)
  file = File.open(file_path, "r")
  file.each_line.map(&:strip)
end

day_num = "15"

part_1_test_result = run_part_1("day#{day_num}_test.txt")
part_1_expected_test_result = 1320
if part_1_test_result != part_1_expected_test_result
  puts "test failed! expected #{part_1_expected_test_result}, got #{part_1_test_result}"
end

part_1_result = run_part_1("day#{day_num}_input.txt")
puts "part 1 result: #{part_1_result}"

part_2_test_result = run_part_2("day#{day_num}_test.txt")
part_2_expected_test_result = 145
if part_2_test_result != part_2_expected_test_result
  puts "test failed! expected #{part_2_expected_test_result}, got #{part_2_test_result}"
end

part_2_result = run_part_2("day#{day_num}_input.txt")
puts "part 2 result: #{part_2_result}"
