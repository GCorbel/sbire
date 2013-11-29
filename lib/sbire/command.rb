require_relative 'sbire_config'
require 'thor'

module Sbire
  class Command < Thor
    package_name "Sbire"

    attr_accessor :command

    desc "start", "Start to listening your voice and execute associated commands"
    def start
      stop
      show("Sbire is listening your voice")
      audio_recorder.start
      audio_converter.start do |results, index|
        command_manager.execute(results, index)
      end
    end

    desc "stop", "Stop all dependencies of Sbire"
    def stop
      audio_recorder.stop
      audio_converter.stop
    end

    desc "save", "Save what you say in #{SbireConfig.text_file}. You can customize the path by edition #{SbireConfig.command_path}"
    def save
      stop
      show("Sbire is listening your voice")
      audio_recorder.start
      recreate_text_file
      audio_converter.start do |results, index|
        save_manager.save(results, index) if results
      end
    end

    desc "pipe", "Send what you say to another command. You can customize the commd by editing #{SbireConfig.command_path}"
    def pipe
      stop
      show("Sbire is listening your voice")
      audio_recorder.start
      audio_converter.start do |results, index|
        pipe_manager.pipe(results, index) if results
      end
    end

    desc "install", "Install Sbire"
    def install
      home = Dir.home
      config_file = "config_#{OS.familly}.yml"
      FileUtils.mkdir_p("#{home}/.sbire/out")
      dirname = File.dirname(__FILE__)
      path = "#{dirname}/../../files/#{config_file}"
      FileUtils.copy(path, "#{home}/.sbire/config.yml")
    end

    private

    def recreate_text_file
      File.write(SbireConfig.text_file, '')
    end

    def command_manager
      @command_manager ||= CommandManager.new(SbireConfig.command_path)
    end

    def audio_recorder
      @audio_recorder ||= AudioRecorder.new(SbireConfig.out_file, pid_manager)
    end

    def audio_converter
      @audio_converter ||= AudioConverter.new(pid_manager)
    end

    def save_manager
      @save_manager ||= SaveManager.new
    end

    def pipe_manager
      @pipe_manager ||= PipeManager.new
    end

    def show(message)
      Notifier.call(message)
    end

    def pid_manager
      @pid_manager ||= PidManager.new
    end
  end
end
