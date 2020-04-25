# TODO TDD
class MathBowling
  MAX_PIN_COUNT = 10
  # TODO handle case for last frame giving a 3rd roll when scoring a spare/strike
  class Frame
    attr_accessor :rolls, :remaining_pins
    attr_accessor :previous_frame, :next_frame

    def initialize(number)
      @number = number
      @rolls = [nil, nil]
      @remaining_pins = 10
      if last?
        @rolls << nil
      end
    end

    # TODO account for previous frame strikes/spares in calculating score
    def score
      if unplayed?
        nil
      else
        teh_score = 0
        teh_score += local_score
        if !last?
          teh_score += (@next_frame.partial_score if spare?).to_i
          if strike?
            if @next_frame.last?
              teh_score += @next_frame.indexed_roll_score(0)
              teh_score += @next_frame.indexed_roll_score(1)
            else
              teh_score += @next_frame.local_score.to_i
              if @next_frame.strike?
                teh_score += (@next_frame.next_frame.partial_score).to_i
              end
            end
          end
        end
        teh_score
      end
    end

    def local_score
      teh_local_score = 0
      @rolls.count.times do |i|
        teh_local_score += indexed_roll_score(i)
      end
      teh_local_score
    end

    def indexed_roll_score(index)
      roll_score(@rolls[index], @rolls[index - 1])
    end

    def roll_score(roll, previous_roll)
      if roll == 'X'
        MAX_PIN_COUNT
      elsif roll == '/'
        MAX_PIN_COUNT - previous_roll.to_i
      else
        roll.to_i
      end
    end

    def partial_score
      if @rolls[0] == 'X'
        MAX_PIN_COUNT
      else
        @rolls[0]
      end
    end

    def final_roll_score
      @rolls[2] == 'X' ? MAX_PIN_COUNT : @rolls[2]
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
      @rolls[0] == 'X'
    end

    def double_strike?
      @rolls[0] == 'X' && @rolls[1] == 'X' #TODO refactor
    end

    def triple_strike?
      @rolls[0] == 'X' && @rolls[1] == 'X' && @rolls[2] == 'X' #TODO refactor
    end

    def spare?
      @rolls[1] == '/'
    end

    def last?
      @number == MAX_PIN_COUNT
    end

    def roll(fallen_pins=nil)
      fallen_pins ||= random_roll_fallen_pins
      return if done?
      if rolls[0].nil?
        self.rolls[0] = fallen_pins
        self.rolls[0] = 'X' if rolls[0] == MAX_PIN_COUNT
      elsif rolls[1].nil? && !strike?
        self.rolls[1] = fallen_pins
        self.rolls[1] = '/' if score == MAX_PIN_COUNT
      elsif rolls[1].nil? && strike? && last?
        self.rolls[1] = fallen_pins
        self.rolls[1] = 'X' if rolls[1] == MAX_PIN_COUNT
      elsif rolls[2].nil? && last? && cleared?
        self.rolls[2] = fallen_pins
        self.rolls[2] = 'X' if rolls[2] == MAX_PIN_COUNT
        self.rolls[2] = '/' if !double_strike? && (indexed_roll_score(1) + indexed_roll_score(2)) == MAX_PIN_COUNT
      end
      self.remaining_pins = calculate_remaining_pins
    end

    def random_roll_fallen_pins
      (rand*(1 + remaining_pins)).to_i
    end

    def calculate_remaining_pins
      if last? && (spare? || (strike? && rolls[1].nil?) || double_strike?)
        MAX_PIN_COUNT
      elsif last? && strike? && !double_strike? && !rolls[1].nil?
        MAX_PIN_COUNT - rolls[1]
      else
        MAX_PIN_COUNT - local_score
      end
    end

    def unplayed?
      @rolls.count(nil) == @rolls.count
    end

    def done?
      if last?
        cleared? ? !@rolls.last.nil? : @rolls.count(nil) == 1
      else
        cleared? || @rolls.count(nil) == 0
      end
    end
  end
end
