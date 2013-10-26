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
    pid = File.readlines(".pid")[0]
    system("kill #{pid}")
  end

  private
  def write_pid(pid)
    File.open('.pid', 'w') {|file| file.write(pid)}
  end

  def record_audio
    fork { exec "sox -t alsa -r 22050 default #{path} -q" }
  end
end
