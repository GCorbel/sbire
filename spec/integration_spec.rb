require 'sbire'
require 'audio_recorder'
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
    allow(AudioConverter).to receive(:new).and_return(audio_converter)
    allow(CommandManager).to receive(:new).and_return(command_manager)

    allow(audio_recorder).to receive(:exec)
    allow(audio_recorder).to receive(:fork).and_yield.and_return(1)
    allow(command_manager).to receive(:system)

    allow(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
    allow(Notifier).to receive(:system)

    allow(Thread).to receive(:new).and_yield(1)
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

