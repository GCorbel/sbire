module Sbire
  class SaveManager
    def save(hypotheses, index)
      stream_manager.execute(hypotheses, index) do |result|
        append_to_file(result)
      end
    end

    private

    def stream_manager
      @stream_manager ||= StreamManager.new
    end

    def append_to_file(text)
      File.open(SbireConfig.text_file, 'ab+') {|file| file.write(text)}
    end
  end
end
