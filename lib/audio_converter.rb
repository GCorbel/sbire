require 'json'
require 'fileutils'
require 'rest_client'

class AudioConverter
  def start(&block)
    FileUtils.rm_rf("#{SbireConfig.out_path}/.")
    pid = listen_audio(block)
    write_pid(pid)
  end

  def stop
    pid = File.readlines(SbireConfig.converter_pid_file)[0]
    system("kill #{pid}")
  end

  private
  def write_pid(pid)
    File.open(SbireConfig.converter_pid_file, 'w') {|file| file.write(pid)}
  end

  def listen_audio(block)
    fork do
      index = 1
      stop = false

      while stop == false
        if File.exist?(filename(index + 1))
          hypotheses = send_to_google(filename(index))
          block.call(hypotheses)
          index += 1

          stop = true if ENV["mode"] == "test"
        end
        sleep 0.1
      end
    end
  end

  def send_to_google(path)
    file = File.read(path)
    begin
      response = RestClient.post url,
        file,
        content_type: 'audio/x-flac; rate=16000'
      read_response(response.to_str) if response.code == 200
    rescue => e
      puts e
      return [""]
    end
  end

  def filename(index)
    index = "%03d" % index
    "#{SbireConfig.out_file}#{index}.flac"
  end

  def read_response(text)
    data = JSON.parse(text)
    data['hypotheses'].map {|ut| [ut['utterance'], ut['confidence']] }.first
  end

  def url
    lang = SbireConfig.lang
    "https://www.google.com/speech-api/v1/recognize?lang=#{lang}"
  end
end
