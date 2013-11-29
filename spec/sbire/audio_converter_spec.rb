require 'spec_helper'
require 'sbire/audio_converter'
require 'sbire'

module Sbire
  describe AudioConverter do
    subject { AudioConverter.new(pid_manager) }

    let(:pid_manager) { double }
    let(:http_body) { '{"hypotheses":[{"utterance":"Firefox","confidence":0.8}]}' }


    before do
      allow(SbireConfig).to receive(:out_path)
      allow(SbireConfig).to receive(:out_file).
        and_return("./spec/fixtures/out/.audiofile")
      allow(SbireConfig).to receive(:converter_pid_file)
      allow(SbireConfig).to receive(:lang)

      allow(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
      allow(subject).to receive(:fork).and_yield
      allow(pid_manager).to receive(:store)

      response = double
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:to_str).and_return(http_body)
      allow(RestClient).to receive(:post).and_return(response)
    end

    describe "#start" do
      it "start in a subprocess" do
        expect(subject).to receive(:fork)
        subject.start {}
      end

      it "remove all files in the out directory" do
        expect(FileUtils).to receive(:rm_rf).with("#{SbireConfig.out_path}/.")
        subject.start {}
      end

      it "yield the history of results" do
        values, index = nil
        subject.start do |results, i|
          values = results
          index = i
        end
        expect(values).to eq [['Firefox', 0.8]]
        expect(index).to eq 0
      end

      it "store the pid" do
        allow(subject).to receive(:fork).and_yield.and_return(1234)
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
end
