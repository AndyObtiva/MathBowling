module MathBowling
  class Frame
    def roles
      # TODO if 10th give 3 roles
      [nil, nil]
    end

    def score
      nil
    end

    def done?
      # !!roles[0] && !!roles[1] && !!score
      false
    end
  end
end
