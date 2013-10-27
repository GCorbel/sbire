require_relative '../lib/sbire'
require_relative '../lib/audio_recorder'

describe Sbire do
  let(:out_file) { "spec/fitures/audio.flac" }
  let(:audio_recorder) {  AudioRecorder.new(out_file) }
  let(:http_request) { Curl::Easy.new('http://www.google.com') }
  let(:command_manager) { CommandManager.new("spec/fixtures/commands.yml") }

  before do
    Sbire::OUT_FILE = "spec/fixtures/audio.flac"
    allow(AudioRecorder).to receive(:new).and_return(audio_recorder)
    allow(audio_recorder).to receive(:exec).with(/sox/)
    allow(audio_recorder).to receive(:fork).and_yield.and_return(1)

    allow(Curl::Easy).to receive(:new).and_return(http_request)
    allow(http_request).to receive(:body).and_return('{"status":0,"id":"b42b1c03f647b9ddd6c843268ebee1e6-1","hypotheses":[{"utterance":"Firefox","confidence":0.8}]}')
    allow(http_request).to receive(:http_post)

    allow(CommandManager).to receive(:new).and_return(command_manager)
    allow(command_manager).to receive(:system)
  end

  it "execute commands said" do
    allow(Notifier).to receive(:system)
    Sbire.run(['start'])
    expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)

    Sbire.run(['stop'])
    expect(Notifier).to have_received(:system).with(/Sbire is analyzing your voice/)

    expect(command_manager).to have_received(:system).with("firefox &")
  end

  it "write phrases said is a file" do
    allow(Notifier).to receive(:system)
    Sbire.run(['start'])
    expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)

    Sbire.run(['save'])
    expect(Notifier).to have_received(:system).with(/Sbire is writing what you said/)

    expect(File.readlines(Sbire::TEXT_FILE)[0]).to eq "Firefox"
  end
end

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
    allow(SaveManager).to receive(:new).with(hypotheses).and_return(save_manager)

    allow(audio_recorder).to receive(:stop)
    allow(audio_recorder).to receive(:start)

    allow(audio_converter).to receive(:results).and_return(hypotheses)
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
      before do
        command = Sbire.new(['start'])
        command.call
      end

      it "show a message" do
        expect(Notifier).to have_received(:call).with("Sbire is listening your voice")
      end

      it "record the voice" do
        expect(audio_recorder).to have_received(:start)
      end
    end

    context "when the command is to stop" do
      before do
        command = Sbire.new(['stop'])
        command.call
      end

      it "show a message" do
        expect(Notifier).to have_received(:call).twice
      end

      it "stop to record the voice" do
        expect(audio_recorder).to have_received(:stop)
      end

      it "execute the command received" do
        expect(command_manager).to have_received(:execute).with(hypotheses)
      end
    end

    context "when the command is to save" do
      before do
        command = Sbire.new(['save'])
        command.call
      end

      it "stop to record the voice" do
        expect(audio_recorder).to have_received(:stop)
      end

      it "save the file recorded" do
        expect(save_manager).to have_received(:save)
      end

      it "show a message" do
        expect(Notifier).to have_received(:call).twice
      end
    end

    context "when the command doest not exist" do
      it "show a message" do
        command = Sbire.new(["something"])
        expect(Notifier).to receive(:call).with("Command not found")
        command.call
      end
    end
  end
end
