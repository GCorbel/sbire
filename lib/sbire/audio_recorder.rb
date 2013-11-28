module Sbire
  class AudioRecorder
    attr_accessor :path, :pid_manager
    def initialize(path, pid_manager)
      @path = path
      @pid_manager = pid_manager
    end

    def start
      pid = record_audio
      pid_manager.store(self, pid)
    end

    def stop
      pid_manager.kill(self)
    end

    private
    def record_audio
      fork { exec "sox -t alsa -r 22050 default #{path}.flac -q silence -l 1 0 1% 1 1.0 1% rate 16k : newfile : restart" }
    end
  end
end
