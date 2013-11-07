require_relative 'notifier'
require_relative 'audio_converter'
require_relative 'command_manager'
require_relative 'audio_recorder'
require_relative 'save_manager'
require_relative 'sbire_config'
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
    @audio_recorder ||= AudioRecorder.new(SbireConfig.out_file)
  end

  def audio_converter
    @audio_converter ||= AudioConverter.new(SbireConfig.out_file)
  end

  def show(message)
    Notifier.call(message)
  end
end
