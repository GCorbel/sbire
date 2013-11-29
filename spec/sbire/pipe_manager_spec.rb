require 'spec_helper'

module Sbire
  describe PipeManager do
    let(:stream_manager) { double }
    let(:hypotheses) { double }

    describe "#pipe" do
      it "send the command receive to a new command" do
        allow(StreamManager).to receive(:new).and_return(stream_manager)
        allow(SbireConfig).to receive(:pipe_command).and_return('pipe "%{text}"')
        allow(stream_manager).to receive(:execute).and_yield('Hello world ')

        expect(subject).to receive(:system).with('pipe "Hello world "')
        subject.pipe(hypotheses, 0)
      end
    end
  end
end
