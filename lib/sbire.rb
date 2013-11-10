require_relative 'notifier'
require_relative 'audio_converter'
require_relative 'command_manager'
require_relative 'audio_recorder'
require_relative 'save_manager'
require_relative 'sbire_config'
require_relative 'pid_manager'
require_relative 'os'
require 'rest_client'

class Sbire

  attr_accessor :command

  def self.run(argv)
    self.new(argv).call
  end

  def initialize(argv)
    @command = argv.first
  end

  def call
    if ["start", "stop", "save", "install"].include?(command)
      send(command)
    else
      show("Command not found")
    end
  end

  private
  def start
    stop
    show("Sbire is listening your voice")
    audio_recorder.start
    audio_converter.start do |results, index|
      command_manager.execute(results, index)
    end
  end

  def stop
    audio_recorder.stop
    audio_converter.stop
  end

  def save
    stop
    show("Sbire is listening your voice")
    audio_recorder.start
    recreate_text_file
    audio_converter.start do |results, index|
      save_manager.save(results, index) if results
    end
  end

  def install
    home = Dir.home
    config_file = "config_#{OS.familly}.yml"
    FileUtils.mkdir_p("#{home}/.sbire/out")
    FileUtils.copy("./files/#{config_file}", "#{home}/.sbire/config.yml")
  end

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

  def show(message)
    Notifier.call(message)
  end

  def pid_manager
    @pid_manager ||= PidManager.new
  end
end
