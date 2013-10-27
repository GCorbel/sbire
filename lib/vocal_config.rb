require 'yaml'

class VocalConfig
  def initialize(path)
    if File.exist?(path)
      @config = YAML.load_file(path)
    end
  end

  def lang
    config["lang"] ||= "en-US"
  end

  private
  def config
    @config ||= {}
  end
end
