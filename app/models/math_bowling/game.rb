require_relative 'score_sheet'

module MathBowling
  class Game
    QUESTION_OPERATIONS = %w[+ - * /]
    attr_accessor :score_sheet, :question, :answer

    def start
      self.score_sheet = MathBowling::ScoreSheet.new
      self.generate_question
    end

    def generate_question
      if self.score_sheet.current_frame.nil?
        teh_question = ''
      else
        begin
          first_number = (rand*10).to_i + 1
          operator = QUESTION_OPERATIONS[(rand*4).to_i]
          last_number = (rand*10).to_i + 1
          teh_question = "#{first_number} #{operator} #{last_number}"
          teh_answer = eval("#{first_number.to_f} #{operator} #{last_number.to_f}")
        end until teh_answer.to_i == teh_answer && teh_answer >= 0
      end
      self.question = teh_question
      self.answer = ''
    end

    def roll
      return if self.score_sheet.current_frame.nil?
      fallen_pins = self.score_sheet.current_frame.pins_remaining - (self.answer.to_i - eval(self.question)).abs
      fallen_pins = [fallen_pins, 0].max
      self.score_sheet.current_frame.roll(fallen_pins)
      self.generate_question
    end

    def play
      restart
      self.score_sheet.frames.each {|frame| 3.times {frame.roll}}
    end

    def restart
      start
    end

    def quit
      self.score_sheet = nil
    end

    # TODO TDD
    def not_started?
      !score_sheet
    end

    # TODO TDD
    def started?
      !not_started?
    end

    # TODO TDD
    def in_progress?
      started? && !score_sheet.game_over?
    end

    # TODO TDD
    def not_in_progress?
      !in_progress?
    end

    # TODO TDD
    def over?
      started? && score_sheet.game_over?
    end
  end
end
