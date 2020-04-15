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
    PLAYER_COUNT_MAX = 4
    # players refers to current players in game. all players refers to all potential players (4 max)
    attr_accessor :player_count, :players, :current_players, :current_player, :question, :answer, :answer_result, :is_one_player, :is_two_players, :roll_done

    def initialize
      self.players = PLAYER_COUNT_MAX.times.map { |player_index| MathBowling::Player.new(player_index) }
    end

    def single_player?
      player_count == 1
    end

    def start
      self.players.each(&:reset)
      self.current_players = players[0..player_count]
      self.current_player = current_players.first
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

    def demo
      # restart
      # self.current_player.score_sheet.frames.each {|frame| 3.times {frame.roll}}
      9.times do
        2.times {self.current_player.score_sheet.current_frame&.roll}
        self.current_player.score_sheet.switch_to_next_frame
        self.switch_player
      end
    end

    def restart
      quit
      start
    end

    def quit
      self.current_players = nil
      self.current_player = nil
      self.question = nil
      self.answer = ''
    end

    def switch_player
      self.current_player = current_players[(current_players.index(current_player) + 1) % player_count]
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
      started? && current_players.map {|player| player.score_sheet.game_over?}.reduce(:&)
    end

    def winner_total_score
      total_scores = players.to_a.map(&:score_sheet).map(&:total_score)
      total_scores.max
    end

    def winners
      if single_player?
        [players.first]
      else
        players.to_a.select {|p| p.score_sheet.total_score == winner_total_score}
      end
    end

    def winner
      winners.first
    end

    def status
      if single_player?
        'WIN'
      else
        if winners.size == players.to_a.size
          'DRAW'
        else
          'WIN'
        end
      end
    end

    def calculate_answer
      return if question.nil?
      first_number, operator, last_number = question.split(' ')
      operator = TRANSLATION.invert[operator]
      eval("#{first_number.to_f} #{operator} #{last_number.to_f}")
    end
  end
end
