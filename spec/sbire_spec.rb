require_relative '../lib/sbire'
require_relative '../lib/audio_recorder'
require 'spec_helper'

describe Sbire do
  let(:out_file) { "#{out_path}/.audiofile" }
  let(:out_path) { "spec/fixtures/out" }
  let(:audio_recorder) {  AudioRecorder.new(out_file, pid_manager) }
  let(:audio_converter) {  AudioConverter.new(pid_manager) }
  let(:command_manager) { CommandManager.new("spec/fixtures/commands.yml") }
  let(:pid_manager) { PidManager.new }

  before do
    allow(SbireConfig).to receive(:base_directory).and_return("./spec/fixtures/")

    allow(AudioRecorder).to receive(:new).and_return(audio_recorder)
    allow(audio_recorder).to receive(:exec).with(/sox/)
    allow(audio_recorder).to receive(:fork).and_yield.and_return(1)

    allow(AudioConverter).to receive(:new).and_return(audio_converter)

    allow(CommandManager).to receive(:new).and_return(command_manager)
    allow(command_manager).to receive(:system)

    allow(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
    allow(Notifier).to receive(:system)
  end

  it "execute commands said" do
    expect(audio_converter).to receive(:fork).and_yield.and_return(2)
    VCR.use_cassette('synopsis') do
      Sbire.run(['start'])
      expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)

      expect(command_manager).to have_received(:system).with("chromium-browser &")
    end
  end

  it "write phrases said is a file" do
    expect(audio_converter).to receive(:fork).and_yield.and_return(2)
    VCR.use_cassette('synopsis') do
      Sbire.run(['save'])
      expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)

      expect(File.readlines(SbireConfig.text_file)[0]).to eq "chrome "
    end
  end

  it "stop all process" do
    expect(pid_manager).to receive(:system).with("kill 1")
    expect(pid_manager).to receive(:system).with("kill 2")
    Sbire.run(['stop'])
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

      it "stop to record the voice" do
        expect(audio_recorder).to have_received(:stop)
      end

      it "stop to listen" do
        expect(audio_converter).to have_received(:stop)
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
