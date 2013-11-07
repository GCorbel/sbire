require 'audio_converter'
require 'sbire'
require 'spec_helper'

describe AudioConverter do
  subject { AudioConverter.new(pid_manager) }

  let(:pid_manager) { double }

  before do
    allow(SbireConfig).to receive(:out_path).and_return("./spec/fixtures/out/")
    allow(SbireConfig).to receive(:out_file).and_return("./spec/fixtures/out/.audiofile")
    allow(SbireConfig).to receive(:converter_pid_file).and_return("./spec/fixtures/.convert.pid")
    allow(SbireConfig).to receive(:lang).and_return("fr-fr")
  end

  describe "#start" do
    before do
      allow(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
      allow(subject).to receive(:fork).and_yield.and_return(1234)
      allow(pid_manager).to receive(:store)

      http_body = '{"status":0,"id":"b42b1c03f647b9ddd6c843268ebee1e6-1","hypotheses":[{"utterance":"Firefox","confidence":0.8}]}'

      response = double
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:to_str).and_return(http_body)

      allow(RestClient).to receive(:post).and_return(response)
    end

    it "start in a subprocess" do
      expect(subject).to receive(:fork)
      subject.start {}
    end

    it "remove all files in the out directory" do
      expect(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
      subject.start {}
    end

    it "yield the result of a http request" do
      text = ''
      subject.start { |result| text += result.first }
      expect(text).to eq 'Firefox'
    end

    it "store the pid" do
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
