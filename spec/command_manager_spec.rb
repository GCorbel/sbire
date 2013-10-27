require_relative '../lib/command_manager'

describe CommandManager do
  subject { CommandManager.new('spec/fixtures/commands.yml') }
  describe "#execute" do
    it "execute the first command" do
      hypotheses = ['firefox', 0.8]
      expect(subject).to receive(:system).with('firefox &')
      subject.execute(hypotheses)
    end

    context "search in the commands file" do
      context "when there is a single phrase binded with the command" do
        it "execute the command binded" do
          hypotheses = ['open skype', 0.8]
          expect(subject).to receive(:system).with('skype &')
          subject.execute(hypotheses)
        end
      end

      context "when there is multiple phrases binded with the command" do
        it "search in the phrases" do
          hypotheses = ['open chrome', 0.8]
          expect(subject).to receive(:system).with('chromium-browser &')
          subject.execute(hypotheses)
        end
      end
    end
  end
end
