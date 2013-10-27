require 'curb'
require 'json'

class AudioConverter
  attr_accessor :file

  def initialize(file_path)
    @file = File.read(file_path)
  end

  def results
    http_request.http_post
    read_response(http_request)
  end

  private
  def read_response(http_request)
    data = JSON.parse(http_request.body)
    data['hypotheses'].map {|ut| [ut['utterance'], ut['confidence']] }.first
  end

  def http_request
    return @http_request if @http_request
    http_request = Curl::Easy.new(url)
    http_request.headers['Content-Type'] = "audio/x-flac; rate=22050"
    http_request.post_body = "Content=#{file}"
    @http_request = http_request
  end

  def url
    lang = Sbire::CONFIG.lang
    "https://www.google.com/speech-api/v1/recognize?lang=#{lang}"
  end
end
