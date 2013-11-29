require 'spec_helper'

module Sbire
  describe Command do
    let(:audio_recorder) { double }
    let(:command_manager) { double }
    let(:audio_converter) { double }
    let(:save_manager) { double }
    let(:pipe_manager) { double }
    let(:hypotheses) { double }

    before do
      allow(Notifier).to receive(:call)
      allow(AudioConverter).to receive(:new).and_return(audio_converter)
      allow(AudioRecorder).to receive(:new).and_return(audio_recorder)
      allow(CommandManager).to receive(:new).and_return(command_manager)
      allow(SaveManager).to receive(:new).and_return(save_manager)
      allow(PipeManager).to receive(:new).and_return(pipe_manager)

      allow(audio_recorder).to receive(:stop)
      allow(audio_recorder).to receive(:start)

      allow(audio_converter).to receive(:start)
      allow(audio_converter).to receive(:stop)
      allow(command_manager).to receive(:execute)
      allow(save_manager).to receive(:save)
      allow(pipe_manager).to receive(:pipe)

      allow(SbireConfig).to receive(:out_file)
      allow(SbireConfig).to receive(:command_path)
    end

    describe "#start" do
      after { subject.start }

      it "stop all process before to continue" do
        expect(subject).to receive(:stop)
      end

      it "show a message" do
        expect(Notifier).to receive(:call).with("Sbire is listening your voice")
      end

      it "record the voice" do
        expect(audio_recorder).to receive(:start)
      end

      it "send data to the command manager" do
        data, index = double, double
        expect(audio_converter).to receive(:start).and_yield(data, index)
        expect(command_manager).to receive(:execute).with(data, index)
      end
    end

    describe "#stop" do
      after { subject.stop }

      context "when the command is to stop" do
        it "stop to record the voice" do
          expect(audio_recorder).to receive(:stop)
        end

        it "stop to listen" do
          expect(audio_converter).to receive(:stop)
        end
      end
    end

    describe "#save" do
      let(:text_path) { './spec/fixtures/text' }

      after { subject.save }

      before do
        allow(FileUtils).to receive(:rm)
        allow(FileUtils).to receive(:touch)
        allow(audio_converter).to receive(:start)
        allow(SbireConfig).to receive(:text_file).and_return(text_path)
      end

      it "stop all process before to continue" do
        expect(subject).to receive(:stop)
      end

      it "show a message" do
        expect(Notifier).to receive(:call).with("Sbire is listening your voice")
      end

      it "record the voice" do
        expect(audio_recorder).to receive(:start)
      end

      it "send data to the save manager" do
        data, index = double, double
        expect(audio_converter).to receive(:start).and_yield(data, index)
        expect(save_manager).to receive(:save).with(data, index)
      end

      it "recreate the text file" do
        expect(File).to receive(:write).with(text_path, '')
      end
    end

    describe "#install" do
      after { subject.install }

      before do
        expect(Dir).to receive(:home).and_return("/home")
        allow(FileUtils).to receive(:copy)
        allow(FileUtils).to receive(:mkdir_p)
        expect(OS).to receive(:familly).and_return("mac")
      end

      it "create a .sbire directory in the home directory" do
        expect(FileUtils).to receive(:mkdir_p).with("/home/.sbire/out")
      end

      it "install the config file to the platform" do
        expect(FileUtils).to receive(:copy).
          with("/home/dougui/rails/sbire/lib/sbire/../../files/config_mac.yml",
               "/home/.sbire/config.yml")
      end
    end

    describe "#pipe" do
      after { subject.pipe }

      it "stop all process before to continue" do
        expect(subject).to receive(:stop)
      end

      it "show a message" do
        expect(Notifier).to receive(:call).with("Sbire is listening your voice")
      end

      it "record the voice" do
        expect(audio_recorder).to receive(:start)
      end

      it "send data to the pipe manager" do
        data, index = double, double
        expect(audio_converter).to receive(:start).and_yield(data, index)
        expect(pipe_manager).to receive(:pipe).with(data, index)
      end
    end
  end
end
