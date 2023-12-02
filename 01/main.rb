# internal API goes up here
REPLACEMENTS = {
  'twone'     => '21',
  'eightwo'   => '82',
  'eighthree' => '83',
  'oneight'   => '18',
  'threeight' => '38',
  'fiveight'  => '58',
  'sevenine'  => '79',
  'one'       => '1',
  'two'       => '2',
  'three'     => '3',
  'four'      => '4',
  'five'      => '5',
  'six'       => '6',
  'seven'     => '7',
  'eight'     => '8',
  'nine'      => '9',
}

def p1(raw)
  raw
    .gsub(/[a-z]+/, '')
    .each_line(chomp: true)
    .sum { |line| "#{line[0]}#{line[-1]}".to_i }
end

def p2(raw)
  exp = /twone|eightwo|eighthree|oneight|threeight|fiveight|sevenine|one|two|three|four|five|six|seven|eight|nine/
  p1(raw.gsub(exp, REPLACEMENTS))
end

#external API goes down here
module Solutions
  def self.test
    p p1(File.read("01/test"))
    p p2(File.read("01/test2"))
  end

  def self.puzzle
    raw = File.read("01/puzzle")
    p p1(raw)
    p p2(raw)
  end
end
