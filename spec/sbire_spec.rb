require 'sbire'

describe Sbire do
  let(:audio_recorder) { double }
  let(:command_manager) { double }
  let(:audio_converter) { double }
  let(:save_manager) { double }
  let(:hypotheses) { double }

  before do
    allow(Notifier).to receive(:call)
    allow(AudioConverter).to receive(:new).and_return(audio_converter)
    allow(AudioRecorder).to receive(:new).and_return(audio_recorder)
    allow(CommandManager).to receive(:new).and_return(command_manager)
    allow(SaveManager).to receive(:new).and_return(save_manager)

    allow(audio_recorder).to receive(:stop)
    allow(audio_recorder).to receive(:start)

    allow(audio_converter).to receive(:start)
    allow(audio_converter).to receive(:stop)
    allow(command_manager).to receive(:execute)
    allow(save_manager).to receive(:save)
  end

  describe ".run" do
    it "call an instance of Sbire" do
      argv = double
      sbire = double

      allow(Sbire).to receive(:new).with(argv).and_return(sbire)
      expect(sbire).to receive(:call)
      Sbire.run(argv)
    end
  end

  describe "#call" do
    context "when the command is to start" do
      let(:command) { Sbire.new(['start']) }

      it "show a message" do
        expect(Notifier).to receive(:call).with("Sbire is listening your voice")
        command.call
      end

      it "record the voice" do
        expect(audio_recorder).to receive(:start)
        command.call
      end

      it "send data to the command manager" do
        data, index = double, double
        expect(audio_converter).to receive(:start).and_yield(data, index)
        expect(command_manager).to receive(:execute).with(data, index)
        command.call
      end
    end

    context "when the command is to stop" do
      let(:command) { Sbire.new(['stop']) }

      it "stop to record the voice" do
        expect(audio_recorder).to receive(:stop)
        command.call
      end

      it "stop to listen" do
        expect(audio_converter).to receive(:stop)
        command.call
      end
    end

    context "when the command doest not exist" do
      it "show a message" do
        command = Sbire.new(["something"])
        expect(Notifier).to receive(:call).with("Command not found")
        command.call
      end
    end

    context "when the command is to save" do
      let(:command) { Sbire.new(['save']) }

      before do
        allow(FileUtils).to receive(:rm)
        allow(audio_converter).to receive(:start)
      end

      it "show a message" do
        expect(Notifier).to receive(:call).with("Sbire is listening your voice")
        command.call
      end

      it "record the voice" do
        expect(audio_recorder).to receive(:start)
        command.call
      end

      it "send data to the save manager" do
        data, index = double, double
        expect(audio_converter).to receive(:start).and_yield(data, index)
        expect(save_manager).to receive(:save).with(data, index)
        command.call
      end
    end
  end
end
