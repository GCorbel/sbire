require_relative '../lib/audio_converter'
require_relative '../lib/sbire'
require 'spec_helper'

describe AudioConverter do
  subject { AudioConverter.new }

  let(:audio_to_text) { double }

  before do
    sbire_config = SbireConfig
    allow(SbireConfig).to receive(:new).and_return(sbire_config)
    allow(sbire_config).to receive(:base_directory).and_return("./spec/fixtures/")
  end

  describe  "#start" do
    before do
      allow(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
      allow(subject).to receive(:fork).and_yield

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
  end
end
