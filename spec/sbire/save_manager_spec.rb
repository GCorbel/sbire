require 'spec_helper'

module Sbire
  describe SaveManager do
    let(:file) { double }
    let(:stream_manager) { double }
    let(:hypotheses) { double }

    describe "#save" do
      it "append to a file" do
        allow(SbireConfig).to receive(:text_file).and_return('text_file')
        allow(StreamManager).to receive(:new).and_return(stream_manager)
        allow(File).to receive(:open).and_yield(file)

        allow(stream_manager).to receive(:execute).and_yield('Hello world ')
        expect(File).to receive(:open).with(SbireConfig.text_file, 'ab+').
          and_yield(file)
        expect(file).to receive(:write).with('Hello world ')
        subject.save(hypotheses, 1)
      end
    end
  end
end
