require_relative 'game'

class MathBowling
  class VideoRepository
    BOWLING_PIN_STATES = ['full', 'partial']

    class << self
      def video_paths_by_answer_result_and_pin_state
        @video_paths_by_answer_result_and_pin_state ||= index_by_answer_result_and_pin_state do |answer_result, pin_state|
          Dir.glob(File.join(APP_ROOT, 'videos', "bowling-#{answer_result.downcase}-#{pin_state}*")).to_a
        end
      end
  
      def index_by_answer_result_and_pin_state(&content_provider)
        Game::ANSWER_RESULTS.reduce({}) do |answer_result_hash, answer_result|
          answer_result_hash.merge(answer_result => BOWLING_PIN_STATES.reduce({}) do |pin_state_hash, pin_state|
            pin_state_hash.merge(pin_state => content_provider.call(answer_result, pin_state))
          end)
        end
      end
    end
  end
end
