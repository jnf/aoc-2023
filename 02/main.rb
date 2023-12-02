# internal API goes up here

Game  = Struct.new(:game_id, :rounds, :min_set)
Round = Struct.new(:blue, :red, :green, :power){ def initialize(blue: 0, red: 0, green: 0, power: 0); super; end }
P1Max = Round.new(blue: 14, red: 12, green: 13)

def p1 (games)
  games
    .select { |game| game.rounds.all? do |rnd|
      rnd.blue <= P1Max.blue &&
      rnd.red <= P1Max.red &&
      rnd.green <= P1Max.green
    end }
    .sum(&:game_id)
end

def p2 (games)
  games.each do |game|
    mred = game.rounds.max_by(&:red).red
    mblue = game.rounds.max_by(&:blue).blue
    mgreen = game.rounds.max_by(&:green).green
    game.min_set = Round.new(blue: mblue, red: mred, green: mgreen)
    game.min_set.power = mred * mblue * mgreen
  end

  games.map(&:min_set).sum(&:power)
end

def setup (raw)
  raw.reduce([]) do |acc, game_str|
    game_id, rest = game_str.match(/^Game\s+(\d+):\s+(.*)/).captures
    rounds = rest.split(';').map do |rnd|
      round = Round.new
      rnd.split(/,\s+/).each do |e|
        count,color = e.match(/(\d+)\s(\w+)/).captures
        round.send("#{color}=".to_sym, count.to_i)
      end
      round
    end
    acc << Game.new(game_id.to_i, rounds)
  end
end

#external API goes down here
module Solutions
  def self.test
    games = Tools::enum_from_file('02/test')
    pp p1(setup(games))
    pp p2(setup(games))
  end

  def self.puzzle
    games = Tools::enum_from_file('02/puzzle')
    pp p1(setup(games))
    pp p2(setup(games))
  end
end
