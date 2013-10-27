require_relative '../lib/vocal_config'

describe VocalConfig do
  describe ".lang" do
    context "when the config file does not exist" do
      it "get the default language" do
        config = VocalConfig.new('non_existing_file')
        expect(config.lang).to eq "en-US"
      end
    end

    context "with an exisiting config file" do
      it "get the default language" do
        config = VocalConfig.new('spec/fixtures/config.yml')
        expect(config.lang).to eq "fr-FR"
      end
    end
  end
end
