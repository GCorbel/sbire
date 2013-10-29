require 'curb'
require 'json'
require 'speech'

class AudioConverter
  attr_accessor :audio

  def initialize(file_path)
    @audio = Speech::AudioToText.new(file_path)
  end

  def results
    [audio.to_text(1, Sbire::CONFIG.lang)]
  end
end
