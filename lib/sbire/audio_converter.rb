module Sbire
  class AudioConverter
    attr_accessor :pid_manager
    def initialize(pid_manager)
      @pid_manager = pid_manager
    end

    def start(&block)
      FileUtils.rm_rf("#{SbireConfig.out_path}/.")
      pid = listen_audio(block)
      pid_manager.store(self, pid)
    end

    def stop
      pid_manager.kill(self)
    end

    private

    def listen_audio(block)
      fork do
        index = 1
        stop = false
        hypotheses = []

        while stop == false
          Thread.new(index) do |i|
            if File.exist?(filename(i + 1))
              index += 1
              hypotheses[i - 1] = send_to_google(filename(i))
              block.call(hypotheses, i - 1)
              stop = true if ENV["mode"] == "test"
            end
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
        response = read_response(response.to_str) if response.code == 200
        if response
          return response
        else
          return empty_result
        end
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
      if text && text.empty?
        empty_result
      else
        data = JSON.parse(text)
        data['hypotheses'].map {|ut| [ut['utterance'], ut['confidence']] }.first
      end
    end

    def empty_result
      ['', 0]
    end

    def url
      lang = SbireConfig.lang
      "https://www.google.com/speech-api/v1/recognize?lang=#{lang}"
    end
  end
end
