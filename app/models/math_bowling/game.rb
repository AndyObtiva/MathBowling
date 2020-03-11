require_relative 'player'

module MathBowling
  class Game
    QUESTION_OPERATIONS = %w[+ - * /]
    attr_accessor :player_count, :players, :current_player, :question, :answer, :is_one_player, :is_two_players

    def initialize
      self.is_one_player = true
    end

    def start
      self.players = player_count.times.map { MathBowling::Player.new }
      self.current_player = players.first
      self.generate_question
    end

    def generate_question
      if current_player.score_sheet.current_frame.nil?
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
      return if self.current_player.score_sheet.current_frame.nil?
      fallen_pins = self.current_player.score_sheet.current_frame.pins_remaining - (self.answer.to_i - eval(self.question)).abs
      fallen_pins = [fallen_pins, 0].max
      self.current_player.score_sheet.current_frame.roll(fallen_pins)
      self.generate_question
      if self.current_player.score_sheet.current_frame.done?
        self.current_player.score_sheet.switch_to_next_frame
        self.switch_player
      end
      if over?
        self.question = ''
      end
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
    end

    def switch_player
      self.current_player = players[(players.index(current_player) + 1) % players.count]
    end

    def is_one_player=(value)
      pd value, caller: true
      @is_one_player = value
      @is_two_players = false
      self.player_count = 1
    end

    def is_two_players=(value)
      pd value, caller: true
      @is_two_players = value
      @is_one_player = false
      self.player_count = 2
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
  end
end
