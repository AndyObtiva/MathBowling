require_relative 'player'

module MathBowling
  class Game
    QUESTION_OPERATIONS = %w[+ - * /]
    TRANSLATION = {
      '+' => '+',
      '-' => '−',
      '*' => '×',
      '/' => '÷',
    }
    ANSWER_RESULTS = [
      'CORRECT',
      'WRONG',
      'CLOSE'
    ]
    attr_reader :player_count
    attr_accessor :players, :current_player, :question, :answer, :answer_result, :is_one_player, :is_two_players, :roll_done

    def initialize(player_count = 1)
      self.player_count = player_count
    end

    def start
      self.players = player_count.times.map { |player_index| MathBowling::Player.new(player_index) }
      self.current_player = players.first
      self.generate_question
      self.answer_result = nil
    end

    def generate_question
      if current_player.score_sheet.current_frame.nil?
        teh_question = ''
      else
        begin
          first_number = (rand*10).to_i + 1
          operator = QUESTION_OPERATIONS[(rand*4).to_i]
          last_number = (rand*10).to_i + 1
          teh_question = "#{first_number} #{TRANSLATION[operator]} #{last_number}"
          teh_answer = eval("#{first_number.to_f} #{operator} #{last_number.to_f}")
        end until teh_answer.to_i == teh_answer && teh_answer >= 0
      end
      self.answer = ''
      self.question = teh_question
    end

    def roll
      return if question.nil?
      self.roll_done = false
      return if self.current_player.score_sheet.current_frame.nil?
      pins_remaining = self.current_player.score_sheet.current_frame.pins_remaining
      fallen_pins = pins_remaining - (self.answer.to_i - calculate_answer).to_i.abs
      fallen_pins = [fallen_pins, 0].max
      if fallen_pins == pins_remaining
        self.answer_result = 'CORRECT'
      elsif fallen_pins == 0
        self.answer_result = 'WRONG'
      else
        self.answer_result = 'CLOSE'
      end
      self.current_player.score_sheet.current_frame.roll(fallen_pins)
      self.generate_question
      if self.current_player.score_sheet.current_frame.done?
        self.current_player.score_sheet.switch_to_next_frame
        self.switch_player
      end
      if over?
        self.question = ''
      end
      self.roll_done = true
    end

    def play
      restart
      self.current_player.score_sheet.frames.each {|frame| 3.times {frame.roll}}
    end

    def restart
      start
    end

    def quit
      self.players = nil
      self.current_player = nil
      self.question = nil
      self.answer = ''
    end

    def switch_player
      self.current_player = players[(players.index(current_player) + 1) % players.count]
    end

    def player_count=(value)
      quit
      @player_count = value
    end

    # TODO TDD
    def not_started?
      !current_player
    end

    # TODO TDD
    def started?
      !not_started?
    end

    # TODO TDD
    def in_progress?
      started? && !current_player.score_sheet.game_over?
    end

    # TODO TDD
    def not_in_progress?
      !in_progress?
    end

    # TODO TDD
    def over?
      started? && players.map {|player| player.score_sheet.game_over?}.reduce(:&)
    end

    def calculate_answer
      return if question.nil?
      first_number, operator, last_number = question.split(' ')
      operator = TRANSLATION.invert[operator]
      eval("#{first_number.to_f} #{operator} #{last_number.to_f}")
    end
  end
end
