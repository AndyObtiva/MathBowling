require_relative 'player'

class MathBowling
  class Game
    QUESTION_OPERATIONS = %w[+ - * /]
    TRANSLATION = {
      '+' => '+',
      '-' => '−',
      '*' => '×',
      '/' => '÷',
    }
    POSSIBLE_FIRST_NUMBERS = {
      '-' => (1..10).reduce({}) {|hash, a| hash.merge(a => (1..10).map {|b| a + b }) },
      '/' => (1..10).reduce({}) {|hash, a| hash.merge(a => (1..10).map {|b| a * b }) },
    }
    ANSWER_RESULTS = [
      'CORRECT',
      'WRONG',
      'CLOSE'
    ]
    PLAYER_COUNT_MAX = 4
    DIFFICULT_QUESTION_EVERY = 5

    # players refers to current players in game. all players refers to all potential players (4 max)
    attr_accessor :player_count, :players, :current_players, :current_player, :question, :answer, :answer_result, 
                  :is_one_player, :is_two_players, :roll_done, :correct_answer, :remaining_pins, :fallen_pins

    def initialize
      self.players = PLAYER_COUNT_MAX.times.map { |player_index| MathBowling::Player.new(player_index) }
      @question_index = -2
      @remaining_pins = 10
    end

    def single_player?
      player_count == 1
    end

    def start
      self.remaining_pins = 10
      self.players.each(&:reset)
      self.current_players = players[0...player_count]
      self.current_player = current_players.first
      self.generate_question
      self.answer_result = nil
    end

    def generate_question
      if current_player.score_sheet.current_frame.nil?
        teh_question = ''
      else
        begin          
          first_number = @question_index%DIFFICULT_QUESTION_EVERY != 0 ? (rand*10).to_i + 1 : (rand*6).to_i + 5
          operator = @question_index%DIFFICULT_QUESTION_EVERY != 0 ? QUESTION_OPERATIONS[(rand*4).to_i] : '*'
          if ['-', '/'].include?(operator)            
            last_number = first_number
            first_number = POSSIBLE_FIRST_NUMBERS[operator][last_number][(rand*10).to_i]
          else
            last_number = @question_index%DIFFICULT_QUESTION_EVERY != 0 ? (rand*10).to_i + 1 : (rand*6).to_i + 5
          end
          teh_question = "#{first_number} #{TRANSLATION[operator]} #{last_number}"
          teh_answer = eval("#{first_number.to_f} #{operator} #{last_number.to_f}")
          positive_integer_answer = (teh_answer.to_i == teh_answer) && (teh_answer >= 0)
          @question_index += 1 if positive_integer_answer
        end until positive_integer_answer
      end
      self.answer = ''
      self.question = teh_question
    end

    def roll
      return if question.nil? || question.empty?
      self.roll_done = false
      return if self.current_player.score_sheet.current_frame.nil?
      @remaining_pins = self.current_player.score_sheet.current_frame.remaining_pins
      @correct_answer = calculate_answer
      @fallen_pins = @remaining_pins - (self.answer.to_i - @correct_answer).to_i.abs
      @fallen_pins = [fallen_pins, 0].max
      if @fallen_pins == @remaining_pins
        self.answer_result = 'CORRECT'
      elsif @fallen_pins == 0
        self.answer_result = 'WRONG'
      else
        self.answer_result = 'CLOSE'
      end
      self.current_player.score_sheet.current_frame.roll(@fallen_pins)
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
      roll until over?
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
      started? and
        current_players.map {|player| player.score_sheet.game_over?}.reduce(:&)
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
