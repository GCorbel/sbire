require_relative '../lib/audio_converter'
require_relative '../lib/sbire'

describe AudioConverter do
  subject { AudioConverter.new('custom_path') }

  let(:audio_to_text) { double }

  before do
    allow(Speech::AudioToText).to receive(:new).and_return(audio_to_text)
  end

  describe "#results" do
    it "send the result return by the http request" do
      allow(Sbire::CONFIG).to receive(:lang).and_return('ab-CD')
      expect(audio_to_text).to receive(:to_text).with(1, 'ab-CD').and_return('Firefox')
      expect(subject.results).to eq ['Firefox']
    end
  end
end
