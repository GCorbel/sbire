module Sbire
  class PipeManager
    def pipe(hypotheses, index)
      stream_manager.execute(hypotheses, index) do |result|
        send_command(result)
      end
    end

    private

    def stream_manager
      @stream_manager ||= StreamManager.new
    end

    def send_command(text)
      command = SbireConfig.pipe_command % { text: text }
      system(command)
    end
  end
end
