# internal API goes up here
def process (raw)
  grid = raw.reduce([]) { |a, l| a << l.each_char.to_a }
end

def is_part? (grid, part, ci, row, ri, end_of_row=false, match_pattern=/[^\.\d]/)
  ecol = ci > row.length ? row.length : ci
  scol = ci - part.length - 1 < 0 ? 0 : ci - part.length - 1
  scol += 1 if end_of_row
  srow = ri - 1 < 0 ? 0 : ri - 1
  erow = ri + 1 > grid.length - 1 ? grid.length - 1 : ri + 1
  subset = (srow..erow).reduce([]) do |a, subrow|
    a << grid[subrow][scol..ecol]
  end

  subset.join.match?(match_pattern)
end

def p1 (grid, parts=[])
  grid.each_with_index do |row, ri|
    part = ''
    row.each_with_index do |col, ci|
      if col =~ /\d/
        part << col
        if ci == row.length - 1 && part.length > 0
          parts << part if is_part?(grid, part, ci, row, ri, true)
        end
      elsif part.length > 0
        parts << part if is_part?(grid, part, ci, row, ri)
        part = ''
      end
    end
  end

  parts.sum(&:to_i)
end

def p2 (grid)
  gear_coords = []
  grid.each_with_index do |row, ri|
    row.each_with_index do |col, ci|
      gear_coords << [ri,ci] if col == '*'
    end
  end

  nums = gear_coords.reduce({}) do |acc, (gr, gc)|
    gear_nums = [
      [gr-1, gc-1], [gr-1, gc], [gr-1, gc+1],
      [gr, gc-1],                 [gr, gc+1],
      [gr+1, gc-1], [gr+1, gc], [gr+1, gc+1]
    ].select { |(y,x)| grid[y][x].match?(/\d/) }

    acc[[gr,gc]] = gear_nums.reduce({}) do |bcc, (ny,nx)|
      key = [ny]
      n = grid[ny][nx]
      i = -1
      while grid[ny][nx+i] =~ /\d/ && nx + i >= 0 do # go left
        n = grid[ny][nx+i] + n
        i -= 1
      end
      key << nx+i+1

      i = 1
      while grid[ny][nx+i] =~ /\d/ && nx + i <= grid[ny].length do # now go right
        n = n + grid[ny][nx+i]
        i += 1
      end
      key << nx+i-1

      bcc[key] = n.to_i
      bcc
    end

    acc
  end
  
  nums.select { |k, v| v.keys.count == 2 }.sum { |k, v| v.values.inject(&:*) }
end

#external API goes down here
module Solutions
  def self.test
    grid = process(Tools::enum_from_file('03/test'))
    pp (p1(grid))
    pp p2(grid)
  end

  def self.puzzle
    grid = process(Tools::enum_from_file('03/puzzle'))
    pp p1(grid) # 540212
    pp p2(grid) # 87605697
  end
end
