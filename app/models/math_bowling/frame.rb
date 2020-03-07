# TODO TDD
module MathBowling
  # TODO handle case for last frame giving a 3rd roll when scoring a spare/strike
  class Frame
    attr_accessor :rolls
    attr_accessor :previous_frame, :next_frame

    def initialize(number)
      @number = number
      @rolls = [nil, nil]
    end

    # TODO account for previous frame strikes/spares in calculating score
    def score
      if unplayed?
        nil
      else
        teh_score = 0
        teh_score += local_score
        if @next_frame
          teh_score += (@next_frame.partial_score if spare?).to_i
          if strike?
            teh_score += @next_frame.local_score.to_i
            if @next_frame.strike?
              teh_score += (@next_frame.next_frame&.partial_score).to_i
            end
          end
        end
        teh_score
      end
    end

    def local_score
      if cleared?
        10
      else
        @rolls.map(&:to_i).sum
      end
    end

    def partial_score
      if @rolls[0] == 'X'
        10
      else
        @rolls[0]
      end
    end

    def running_score
      teh_running_score = score
      unless teh_running_score.nil?
        teh_previous_frame = self.previous_frame
        while(teh_previous_frame != nil)
          teh_running_score += teh_previous_frame.score.to_i
          teh_previous_frame = teh_previous_frame.previous_frame
        end
      end
      teh_running_score
    end

    def cleared?
      spare? || strike?
    end

    def strike?
      @rolls.include?('X')
    end

    def spare?
      @rolls.include?('/')
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
      score.to_i >= 10 || @rolls.count(nil) == 0
    end
  end
end
