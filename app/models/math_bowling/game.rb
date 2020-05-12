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
      '-' => (1..20).reduce({}) {|hash, a| hash.merge(a => (1..20).map {|b| a + b }) },
      '/' => (1..20).reduce({}) {|hash, a| hash.merge(a => (1..20).map {|b| a * b }) },
    }
    ANSWER_RESULTS = [
      'CORRECT',
      'WRONG',
      'CLOSE'
    ]
    PLAYER_COUNT_MAX = 4
    DIFFICULT_QUESTION_EVERY = 5
    DIFFICULTIES = %i[easy medium hard]
    NUMBER_UPPER_LIMIT = {
      easy: 10,
      medium: 10,
      hard: 20
    }

    attr_reader :player_count
    attr_accessor :players, :current_players, :current_player, :name_current_player, :game_current_player, :question, :answer, :answer_result, 
                  :is_one_player, :is_two_players, :roll_done, :correct_answer, :remaining_pins, :fallen_pins,
                  :last_player_index, :difficulty

    def initialize
      self.players = PLAYER_COUNT_MAX.times.map { |player_index| MathBowling::Player.new(player_index) }
      @question_index = -2
      @remaining_pins = 10
      @last_player_index = 0
    end

    def single_player?
      player_count == 1
    end

    def start
      self.last_player_index = 0
      self.remaining_pins = 10
      self.players.each(&:reset)
      self.current_player = current_players.first
      self.generate_question
      self.answer_result = nil
    end

    def generate_question
      if current_player.score_sheet.current_frame.nil?
        teh_question = ''
      else
        begin          
          number_upper_limit = NUMBER_UPPER_LIMIT[@difficulty]
          first_number = 
          case @difficulty
          when :easy
            (rand*(number_upper_limit / 2)).to_i + 1
          when :medium
            @question_index%DIFFICULT_QUESTION_EVERY != 0 ? (rand*number_upper_limit).to_i + 1 : (rand*(number_upper_limit / 2 + 1)).to_i + (number_upper_limit / 2)
          when :hard
            (rand*number_upper_limit).to_i + 1
          end
          operator = @difficulty == :medium && @question_index%DIFFICULT_QUESTION_EVERY == 0 ? '*' : QUESTION_OPERATIONS[(rand*4).to_i]
          if ['-', '/'].include?(operator)
            last_number = first_number
            first_number = POSSIBLE_FIRST_NUMBERS[operator][last_number][(rand*number_upper_limit).to_i]
          else
            last_number = @difficulty == :easy && @question_index%DIFFICULT_QUESTION_EVERY != 0 ? (rand*number_upper_limit).to_i + 1 : (rand*(number_upper_limit / 2 + 1)).to_i + (number_upper_limit / 2)
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
      self.last_player_index = current_player.index
      return if question.nil? || question.empty?
      self.roll_done = false
      return if self.current_player.score_sheet.current_frame.nil?
      @remaining_pins = self.current_player.score_sheet.current_frame.remaining_pins
      @correct_answer = calculate_answer
      @fallen_pins = @remaining_pins - (self.answer.to_i - @correct_answer).to_i.abs
      @fallen_pins = [fallen_pins, 0].max
      self.current_player.score_sheet.current_frame.roll(@fallen_pins)
      if @fallen_pins == @remaining_pins
        self.answer_result = 'CORRECT'
      elsif @fallen_pins == 0
        self.answer_result = 'WRONG'
      else
        self.answer_result = 'CLOSE'
      end

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
      self.players.each(&:reset)
      self.current_player = nil
      self.question = nil
      self.answer = ''
    end

    def switch_player
      self.current_player = current_players[(current_players.index(current_player) + 1) % player_count]
    end

    def switch_name_player
      self.name_current_player = current_players[(current_players.index(name_current_player) + 1) % player_count]
    end

    def player_count=(value)
      quit
      @player_count = value
      @current_players = players[0...@player_count]
    end

    def not_started?
      !current_player
    end

    def started?
      !not_started?
    end

    def in_progress?
      started? and
        current_player&.score_sheet and
        !current_player.score_sheet.game_over?
    end

    def not_in_progress?
      !in_progress?
    end

    def over?
      started? and
        current_players.map {|player| player&.score_sheet&.game_over?}.reduce(:&)
    end

    def winner_total_score
      total_scores = current_players.to_a.map(&:score_sheet).map(&:total_score)
      total_scores.max
    end

    def winners
      if single_player?
        [players.first]
      else
        current_players.to_a.select {|p| p.score_sheet.total_score == winner_total_score}
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

    def all_player_names_entered?
      current_players.map(&:name).map(&:to_s).count(&:empty?) == 0
    end

    def calculate_answer
      return if question.nil?
      first_number, operator, last_number = question.split(' ')
      operator = TRANSLATION.invert[operator]
      eval("#{first_number.to_f} #{operator} #{last_number.to_f}")
    end
  end
end
