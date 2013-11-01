require_relative '../lib/audio_recorder'
require_relative '../lib/sbire'

describe AudioRecorder do
  subject { AudioRecorder.new('custom_path') }

  let(:recorder) { ExternalTools.recorder('custom_path') }

  before do
    allow(subject).to receive(:exec).with(recorder)
  end

  describe "#start" do
    it "record the audio" do
      expect(subject).to receive(:exec).with(recorder)
      expect(subject).to receive(:fork).and_yield
      subject.start
    end

    it "write the process id" do
      file = double
      allow(subject).to receive(:record_audio).and_return(1)
      allow(File).to receive(:open).and_yield(file)
      expect(file).to receive(:write).with(1)
      subject.start
    end
  end

  describe "#stop" do
    it "kill the process with the readed pid" do
      allow(File).to receive(:readlines).and_return([1])
      expect(subject).to receive(:system).with('kill 1')
      subject.stop
    end
  end
end
