class AudioRecorder
  attr_accessor :path
  def initialize(path)
    @path = path
  end

  def start
    pid = record_audio
    write_pid(pid)
  end

  def stop
    pid = File.readlines(SbireConfig.record_pid_file)[0]
    system("kill #{pid}")
  end

  private
  def write_pid(pid)
    File.open(SbireConfig.record_pid_file, 'w') {|file| file.write(pid)}
  end

  def record_audio
    fork { exec "sox -t alsa -r 22050 default #{path}.flac -q silence -l 1 0 1% 1 1.0 1% rate 16k : newfile : restart" }
  end
end
