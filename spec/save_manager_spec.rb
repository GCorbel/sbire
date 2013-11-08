require 'save_manager'
require 'sbire_config'

describe SaveManager do
  let(:file) { double }

  before do
    allow(SbireConfig).to receive(:text_file).and_return('text_file')
    allow(File).to receive(:open).with(SbireConfig.text_file, 'ab+').and_yield(file)
  end

  describe "#save" do
    it "save to a file" do
      hypotheses = [['Hello'], ['world']]
      expect(file).to receive(:write).with('Hello world ')
      subject.save(hypotheses, 1)
    end

    it "save step by step" do
      hypotheses = [['Hello'], ['world'], ['!!!']]
      expect(file).to receive(:write).with('Hello ')
      subject.save(hypotheses, 0)

      expect(file).to receive(:write).with('world ')
      subject.save(hypotheses, 1)

      expect(file).to receive(:write).with('!!! ')
      subject.save(hypotheses, 2)
    end

    it "does not save two times the same text" do
      hypotheses = [['Hello'], ['world']]
      expect(file).to receive(:write).with('Hello world ')
      subject.save(hypotheses, 1)

      expect(file).to_not receive(:write)
      subject.save(hypotheses, 1)
    end

    it "does not save the next text if the previous is empty" do
      hypotheses = [[nil], ['world']]
      expect(file).to_not receive(:write)
      subject.save(hypotheses, 1)
    end

    it "write until there the hypothese is present" do
      hypotheses = [[nil], ['world']]
      subject.save(hypotheses, 1)

      hypotheses = [['Hello'], ['world']]
      expect(file).to receive(:write).with('Hello world ')
      subject.save(hypotheses, 0)
    end
  end
end
