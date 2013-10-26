require_relative '../lib/audio_converter.rb'

describe AudioConverter do
  subject { AudioConverter.new('custom_path') }

  before do
    expect(File).to receive(:read)
  end

  describe "#results" do
    it "send the result return by the http request" do
      http_request = double
      allow(Curl::Easy).to receive(:new).and_return(http_request).with('https://www.google.com/speech-api/v1/recognize?lang=fr-FR')
      allow(http_request).to receive(:headers).and_return({})
      allow(http_request).to receive(:post_body=)
      allow(http_request).to receive(:http_post)
      allow(http_request).to receive(:body).and_return('{"status":0,"id":"b42b1c03f647b9ddd6c843268ebee1e6-1","hypotheses":[{"utterance":"Firefox","confidence":0.8}]}')

      expect(subject.results).to eq ['Firefox', 0.8]
    end
  end
end
