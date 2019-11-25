require_relative '../../../../app/models/math_bowl/game'

describe MathBowl::Game do
  describe 'score_sheet' do
    it "returns an empty score sheet if no game is started" do
      expect(subject.score_sheet.frames.size).to eq(10)
      subject.score_sheet.frames.each do |frame|
        expect(frame.roles[0]).to eq(nil)
        expect(frame.roles[1]).to eq(nil)
        expect(frame.score).to eq(nil)
      end
      expect(subject.score_sheet.total_score).to eq(0)
      expect(subject.score_sheet.game_over?).to be_falsey
    end
  end
end
