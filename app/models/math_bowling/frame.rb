# TODO TDD
module MathBowling
  # TODO handle case for last frame giving a 3rd roll when scoring a spare/strike
  class Frame
    attr_accessor :rolls

    def initialize
      @rolls = [nil, nil]
    end

    # TODO account for previous frame strikes/spares in calculating score
    def score
      if unplayed?
        nil
      elsif @rolls.include?('/') || @rolls.include?('X')
        10
      else
        @rolls.map(&:to_i).sum
      end
    end

    def roll
      if rolls[0].nil?
        self.rolls[0] = (rand*11).to_i
        self.rolls[0] = 'X' if rolls[0] == 10
      elsif rolls[1].nil? && rolls[0] != 'X'
        self.rolls[1] = (rand*(11 - rolls[0])).to_i
        self.rolls[1] = '/' if score == 10
      end
    end

    def unplayed?
      @rolls.count(nil) == 2
    end

    def done?
      score == 10 || @rolls.count(nil) == 0
    end
  end
end
