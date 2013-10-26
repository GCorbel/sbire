require_relative 'notifier'
require_relative 'audio_converter'
require_relative 'command_manager'
require_relative 'audio_recorder'
require 'rest_client'

class VocalCommand

  OUT_FILE = "/home/dougui/rails/vocal_command/.audiofile.flac"

  attr_accessor :command

  def self.run(argv)
    self.new(argv).call
  end

  def initialize(argv)
    @command = argv.first
  end

  def call
    if command == "start" || command == "stop"
      send(command)
    else
      show("Command not found")
    end
  end

  private
  def start
    audio_recorder.start
    show("Vocal command is listening your voice")
  end

  def stop
    show("Vocal command is analyzing your voice")
    audio_recorder.stop
    hypotheses = audio_converter.results
    show(CommandManager.new(hypotheses).execute)
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
