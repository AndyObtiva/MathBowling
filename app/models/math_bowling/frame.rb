module MathBowling
  # TODO handle case for last frame giving a 3rd roll when scoring a spare/strike
  class Frame
    attr_accessor :roles

    def initialize
      @roles = [nil, nil]
    end

    def score
      unplayed? ? nil : @roles.map(&:to_i).sum
    end

    def roll
      if roles[0].nil?
        self.roles[0] = (rand*11).to_i
      else
        self.roles[1] = (rand*(11 - roles[0])).to_i
      end
    end

    def unplayed?
      @roles.count(nil) == 2
    end

    def done?
      score == 10 || @roles.count(nil) == 0
    end
  end
end
