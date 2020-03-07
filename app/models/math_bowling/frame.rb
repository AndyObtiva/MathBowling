module MathBowling
  class Frame
    attr_accessor :roles

    def initialize
      @roles = [nil, nil]
    end

    def score
      @roles.count(nil) == 2 ? nil : @roles.map(&:to_i).sum
    end

    def done?
      # !!roles[0] && !!roles[1] && !!score
      false
    end
  end
end
