# internal API goes up here
def p1 (grid)
  grid.reduce(0) do |pts, line|
    wins, nums = line.split("|").map { |m| m.scan(/\d+/) }
    wins.shift # first number is the card id
    pts + (2 ** (nums.count - (nums-wins).count - 1)).to_i
  end
end

def p2 (grid)
  list = grid.reduce([]) do |list, line|
    ws, ns = line.split("|").map { |m| m.scan(/\d+/) }
    ws.shift # first number is the card id
    wcnt = ns.count - (ns-ws).count
    list <<  [wcnt, 1] # start w/ 1 copy of each card
  end

  list.each_with_index do |(wcnt, cp), i1|
    list[i1+1, wcnt].each { |imp| imp[1] += cp }
  end

  list.sum(&:last)
end

#external API goes down here
module Solutions
  def self.test
    grid = Tools::enum_from_file('04/test')
    pp p1(grid)
    pp p2(grid)
  end

  def self.puzzle
    grid = Tools::enum_from_file('04/puzzle')
    pp p1(grid) # 26426
    pp p2(grid) # 6227972
  end
end
