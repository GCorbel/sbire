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
    pid = File.readlines(Sbire::PID_FILE)[0]
    system("kill #{pid}")
  end

  private
  def write_pid(pid)
    File.open(Sbire::PID_FILE, 'w') {|file| file.write(pid)}
  end

  def record_audio
    fork { exec "ffmpeg -loglevel quiet -f alsa -ac 2 -i pulse -y #{path} -r 22050" }
  end
end
