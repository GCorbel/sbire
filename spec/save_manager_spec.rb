require 'save_manager'
require 'sbire_config'

describe SaveManager do
  subject { SaveManager.new(hypotheses) }
  let(:hypotheses) { ['Hello world', 0.8] }

  before do
    allow(SbireConfig).to receive(:text_file).and_return('text_file')
  end

  it "save to a file" do
    file = double
    allow(File).to receive(:open).with(SbireConfig.text_file, 'w').and_yield(file)
    expect(file).to receive(:write).with('Hello world')
    subject.save
  end
end
