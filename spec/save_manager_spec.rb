require_relative '../lib/save_manager'
require_relative '../lib/sbire_config'

describe SaveManager do
  subject { SaveManager.new(hypotheses) }
  let(:hypotheses) { ['Hello world', 0.8] }

  before do
    sbire_config = double
    allow(SbireConfig).to receive(:new).and_return(sbire_config)
    allow(sbire_config).to receive(:text_file).and_return('text_file')
  end

  it "save to a file" do
    file = double
    allow(File).to receive(:open).with(SbireConfig.new.text_file, 'w').and_yield(file)
    expect(file).to receive(:write).with('Hello world')
    subject.save
  end
end
