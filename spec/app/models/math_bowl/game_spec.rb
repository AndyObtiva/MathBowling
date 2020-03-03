require_relative '../../../../app/models/math_bowl/game'

describe MathBowl::Game do
  describe 'score_sheet' do
    it "returns nil if no game is started" do
      expect(subject.score_sheet).to be_nil
    end
    it "returns an empty score sheet if game is started" do
      subject.start
      expect(subject.score_sheet.frames.size).to eq(10)
      subject.score_sheet.frames.each do |frame|
        expect(frame.roles[0]).to eq(nil)
        expect(frame.roles[1]).to eq(nil)
        expect(frame.score).to eq(nil)
      end
      expect(subject.score_sheet.total_score).to eq(0)
      expect(subject.score_sheet.game_over?).to be_falsey
    end
    it "returns nil if game is quit" do
      subject.start
      expect(subject.score_sheet).to_not be_nil
      subject.quit
      expect(subject.score_sheet).to be_nil
    end
    it 'returns empty score sheet if game is restarted'

    
  end
end
