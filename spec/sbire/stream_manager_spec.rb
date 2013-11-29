require 'spec_helper'
require 'sbire/stream_manager'

module Sbire
  describe StreamManager do
    describe "#execute" do
      it "send step by step" do
        hypotheses = [['Hello'], ['world'], ['!!!']]
        text = ""

        subject.execute(hypotheses, 0) { |result| text += result }
        expect(text).to eq "Hello "

        subject.execute(hypotheses, 1) { |result| text += result }
        expect(text).to eq "Hello world "

        subject.execute(hypotheses, 2) { |result| text += result }
        expect(text).to eq "Hello world !!! "
      end

      it "does not send two times the same text" do
        hypotheses = [['Hello'], ['world']]
        text = ""

        subject.execute(hypotheses, 1) { |result| text += result }
        expect(text).to eq "Hello world "

        subject.execute(hypotheses, 1) { |result| text += result }
        expect(text).to eq "Hello world "
      end

      it "does not send the next text if the previous is empty" do
        hypotheses = [[nil], ['world']]
        text = ""

        subject.execute(hypotheses, 1) { |result| text += result }
        expect(text).to eq ""
      end

      it "send until there the hypothese is present" do
        hypotheses = [[nil], ['world']]
        text = ""
        subject.execute(hypotheses, 1) { |result| text += result }
        expect(text).to eq ""

        hypotheses = [['Hello'], ['world']]
        subject.execute(hypotheses, 0) { |result| text += result }
        expect(text).to eq "Hello world "
      end
    end
  end
end
