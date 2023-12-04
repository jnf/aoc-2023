# internal API goes up here
def p1 (grid)
  grid.reduce(0) do |pts, line|
    wins, nums = line.split("|").map { |m| m.scan(/\d+/) }
    wins.shift # first number is the card id
    pts + (2 ** (nums.count - (nums-wins).count - 1)).to_i
  end
end


Card = Struct.new(:wcnt, :cp)
def p2 (grid)
  list = grid.reduce([]) do |list, line|
    ws, ns = line.split("|").map { |m| m.scan(/\d+/) }
    ws.shift # first number is the card id
    wcnt = ns.count - (ns-ws).count
    list <<  Card.new(wcnt, 1) # start w/ 1 copy of each card
  end

  list.each_with_index do |card, i1|
    card.cp.times do
      card.wcnt.times do |i2|
        nxt = i1 + i2 + 1
        list[nxt].cp += 1 if list[nxt] # won a copy yay
      end
    end
  end

  list.sum(&:cp)
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
