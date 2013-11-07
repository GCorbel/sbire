require 'notifier'
require 'audio_converter'
require 'command_manager'
require 'audio_recorder'
require 'save_manager'
require 'sbire_config'
require 'pid_manager'
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
    if command == "start" || command == "stop" || command == "save"
      send(command)
    else
      show("Command not found")
    end
  end

  private
  def start
    show("Sbire is listening your voice")
    audio_recorder.start
    audio_converter.start { |result| command_manager.execute(result) }
  end

  def stop
    audio_recorder.stop
    audio_converter.stop
  end

  def save
    show("Sbire is listening your voice")
    audio_recorder.start
    FileUtils.rm(SbireConfig.text_file)
    audio_converter.start do |result|
      File.open(SbireConfig.text_file, 'ab+') {|f| f.write(result.first + " ") }
    end
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

  def show(message)
    Notifier.call(message)
  end

  def pid_manager
    @pid_manager ||= PidManager.new
  end
end
