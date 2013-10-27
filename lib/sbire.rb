require_relative 'notifier'
require_relative 'audio_converter'
require_relative 'command_manager'
require_relative 'audio_recorder'
require_relative 'save_manager'
require_relative 'sbire_config'
require 'rest_client'

class Sbire

  BASE_DIRECTORY = "#{Dir.home}/.sbire"
  OUT_FILE = "#{BASE_DIRECTORY}/.audiofile.flac"
  PID_FILE = "#{BASE_DIRECTORY}/.pid"
  TEXT_FILE = "#{BASE_DIRECTORY}/sbire.txt"
  CONFIG_PATH = "#{BASE_DIRECTORY}/config.yml"
  COMMAND_PATH = "#{BASE_DIRECTORY}/commands.yml"
  CONFIG = SbireConfig.new(CONFIG_PATH)

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
    audio_recorder.start
    show("Sbire is listening your voice")
  end

  def stop
    show("Sbire is analyzing your voice")
    audio_recorder.stop
    hypotheses = audio_converter.results
    show(command_manager.execute(hypotheses))
  end

  def save
    show("Sbire is writing what you said")
    audio_recorder.stop
    hypotheses = audio_converter.results
    SaveManager.new(hypotheses).save
    show("Sbire has ended to write your voice")
  end

  def command_manager
    @command_manager ||= CommandManager.new(COMMAND_PATH)
  end

  def audio_recorder
    @audio_recorder ||= AudioRecorder.new(OUT_FILE)
  end

  def audio_converter
    @audio_converter ||= AudioConverter.new(OUT_FILE)
  end

  def show(message)
    Notifier.call(message)
  end
end
