require 'spec_helper'
require 'sbire'

module Sbire
  describe Command do
    let(:out_file) { "#{out_path}/.audiofile" }
    let(:out_path) { "spec/fixtures/out" }
    let(:audio_recorder) {  AudioRecorder.new(out_file, pid_manager) }
    let(:audio_converter) {  AudioConverter.new(pid_manager) }
    let(:command_manager) { CommandManager.new("spec/fixtures/commands.yml") }
    let(:pid_manager) { PidManager.new }
    let(:pipe_manager) { PipeManager.new }

    before do
      allow(AudioRecorder).to receive(:new).and_return(audio_recorder)
      allow(AudioConverter).to receive(:new).and_return(audio_converter)
      allow(CommandManager).to receive(:new).and_return(command_manager)
      allow(PipeManager).to receive(:new).and_return(pipe_manager)

      allow(audio_recorder).to receive(:exec)
      allow(audio_recorder).to receive(:fork).and_yield.and_return(1)
      allow(command_manager).to receive(:system)
      allow(pipe_manager).to receive(:system)

      allow(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
      allow(Notifier).to receive(:system)

      allow(Thread).to receive(:new).and_yield(1)
    end

    it "execute commands said" do
      expect(audio_converter).to receive(:fork).and_yield.and_return(2)
      VCR.use_cassette('synopsis') do
        subject.start
        expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)

        expect(command_manager).to have_received(:system).with("chromium-browser &")
      end
    end

    it "write phrases said is a file" do
      expect(audio_converter).to receive(:fork).and_yield.and_return(2)
      VCR.use_cassette('synopsis') do
        subject.save
        expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)

        expect(File.readlines(SbireConfig.text_file)[0]).to eq "chrome "
      end
    end

    it "send phrases said to another command" do
      expect(audio_converter).to receive(:fork).and_yield.and_return(2)
      VCR.use_cassette('synopsis') do
        subject.pipe
        expect(Notifier).to have_received(:system).with(/Sbire is listening your voice/)
        expect(pipe_manager).to have_received(:system).with("pipe 'chrome '")
      end
    end

    it "stop all process" do
      expect(pid_manager).to receive(:system).with("kill 1")
      expect(pid_manager).to receive(:system).with("kill 2")
      subject.stop
    end
  end
end
