require 'sbire/audio_recorder'
require 'sbire/sbire_config'

module Sbire
  describe AudioRecorder do
    subject { AudioRecorder.new('custom_path', pid_manager) }

    let(:pid_manager) { double }

    before do
      allow(subject).to receive(:exec)
      allow(subject).to receive(:fork).and_yield
      allow(pid_manager).to receive(:store)
      allow(SbireConfig).to receive(:record_pid_file)
    end

    describe "#start" do
      it "record the audio" do
        expect(subject).to receive(:exec).with(/sox/)
        subject.start
      end

      it "store the pid" do
        allow(subject).to receive(:fork).and_yield.and_return(1234)
        expect(pid_manager).to receive(:store).with(subject, 1234)
        subject.start {}
      end
    end

    describe "#stop" do
      it "kill the process" do
        expect(pid_manager).to receive(:kill).with(subject)
        subject.stop
      end
    end
  end
end
