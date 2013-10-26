require_relative '../lib/command_manager'

describe CommandManager do
  subject { CommandManager.new(hypotheses) }
  let(:hypotheses) { ['firefox', 0.8] }

  describe "#execute" do
    it "execute the first command" do
      expect(subject).to receive(:system).with('firefox &')
      subject.execute
    end
  end
end
