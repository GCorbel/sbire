require 'sbire'

module Sbire
  describe Command do
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

      allow(SbireConfig).to receive(:out_file)
      allow(SbireConfig).to receive(:command_path)
    end

    describe ".run" do
      it "call an instance of Sbire" do
        argv = double
        sbire = double

        allow(Command).to receive(:new).with(argv).and_return(sbire)
        expect(sbire).to receive(:call)
        Command.run(argv)
      end
    end

    describe "#call" do
      context "when the command is to start" do
        subject { Command.new(['start']) }

        it "stop all process before to continue" do
          expect(subject).to receive(:stop)
          subject.call
        end

        it "show a message" do
          expect(Notifier).to receive(:call).with("Sbire is listening your voice")
          subject.call
        end

        it "record the voice" do
          expect(audio_recorder).to receive(:start)
          subject.call
        end

        it "send data to the command manager" do
          data, index = double, double
          expect(audio_converter).to receive(:start).and_yield(data, index)
          expect(command_manager).to receive(:execute).with(data, index)
          subject.call
        end
      end

      context "when the command is to stop" do
        subject { Command.new(['stop']) }

        it "stop to record the voice" do
          expect(audio_recorder).to receive(:stop)
          subject.call
        end

        it "stop to listen" do
          expect(audio_converter).to receive(:stop)
          subject.call
        end
      end

      context "when the command doest not exist" do
        subject { Command.new(["something"]) }
        it "show a message" do
          expect(Notifier).to receive(:call).with("Command not found")
          subject.call
        end
      end

      context "when the command is to save" do
        subject { Command.new(['save']) }
        let(:text_path) { './spec/fixtures/text' }

        before do
          allow(FileUtils).to receive(:rm)
          allow(FileUtils).to receive(:touch)
          allow(audio_converter).to receive(:start)
          allow(SbireConfig).to receive(:text_file).and_return(text_path)
        end

        it "stop all process before to continue" do
          expect(subject).to receive(:stop)
          subject.call
        end

        it "show a message" do
          expect(Notifier).to receive(:call).with("Sbire is listening your voice")
          subject.call
        end

        it "record the voice" do
          expect(audio_recorder).to receive(:start)
          subject.call
        end

        it "send data to the save manager" do
          data, index = double, double
          expect(audio_converter).to receive(:start).and_yield(data, index)
          expect(save_manager).to receive(:save).with(data, index)
          subject.call
        end

        it "recreate the text file" do
          File.write(text_path, 'test')
          subject.call
          expect(File.read(text_path)).to eq ''
        end
      end

      context "when the command is to install" do
        subject { Command.new(["install"]) }

        before do
          expect(Dir).to receive(:home).and_return("/home")
          allow(FileUtils).to receive(:copy)
          allow(FileUtils).to receive(:mkdir_p)
          expect(OS).to receive(:familly).and_return("mac")
        end

        it "create a .sbire directory in the home directory" do
          expect(FileUtils).to receive(:mkdir_p).with("/home/.sbire/out")
          subject.call
        end

        it "install the config file to the platform" do
          expect(FileUtils).to receive(:copy).
            with("/home/dougui/rails/sbire/lib/sbire/../../files/config_mac.yml",
                 "/home/.sbire/config.yml")
          subject.call
        end
      end
    end
  end
end
