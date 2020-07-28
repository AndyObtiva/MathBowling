require_relative '../../../../app/models/math_bowling/game'

describe MathBowling::Game do
  describe 'current_player' do
    let(:score_sheet) {subject.current_player.score_sheet}
    
    it "returns nil if no game is started" do
      expect(subject.current_player).to be_nil
    end
    
    it "returns current_player with an empty score sheet if game is started" do
      subject.player_count = 1
      subject.difficulty = :easy
      subject.start
      expect(subject.current_player).to be_a(MathBowling::Player)
      expect(score_sheet.frames.size).to eq(10)
      score_sheet.frames.each do |frame|
        expect(frame.rolls[0]).to eq(nil)
        expect(frame.rolls[1]).to eq(nil)
        expect(frame.score).to eq(nil)
      end
      expect(score_sheet.total_score).to eq(0)
      expect(score_sheet.game_over?).to be_falsey
    end
    
  end
end
