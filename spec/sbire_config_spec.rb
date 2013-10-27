require_relative '../lib/sbire_config'

describe SbireConfig do
  describe ".lang" do
    context "when the config file does not exist" do
      it "get the default language" do
        config = SbireConfig.new('non_existing_file')
        expect(config.lang).to eq "en-US"
      end
    end

    context "with an exisiting config file" do
      it "get the default language" do
        config = SbireConfig.new('spec/fixtures/config.yml')
        expect(config.lang).to eq "fr-FR"
      end
    end
  end
end
