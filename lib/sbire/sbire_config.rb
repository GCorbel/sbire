require 'yaml'

module Sbire
  class SbireConfig
    def self.config_path
      "#{base_directory}/config.yml"
    end

    def self.base_directory
      if ENV["mode"] == "test"
        "./spec/fixtures"
      else
        "#{Dir.home}/.sbire"
      end
    end

    def self.lang
      config["lang"] ||= "en-US"
    end

    def self.out_path
      config["out_path"] ||= "#{base_directory}/out/"
    end

    def self.out_file
      config["out_file"] ||= "#{out_path}.audiofile"
    end

    def self.text_file
      config["text_file"] ||= "#{base_directory}/text"
    end

    def self.command_path
      config["command_path"] ||= "#{base_directory}/commands.yml"
    end

    def self.notify_command
      config["notify_command"]
    end

    def self.pipe_command
      config["pipe_command"]
    end

    private

    def self.config
      return @config if @config
      @config = YAML.load_file(config_path) || {}
    end
  end
end
