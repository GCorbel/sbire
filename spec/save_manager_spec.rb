require_relative '../lib/save_manager'

describe SaveManager do
  subject { SaveManager.new(hypotheses) }
  let(:hypotheses) { ['Hello world', 0.8] }

  it "save to a file" do
    file = double
    allow(File).to receive(:open).with(VocalCommand::TEXT_FILE, 'w').and_yield(file)
    expect(file).to receive(:write).with('Hello world')
    subject.save
  end
end
