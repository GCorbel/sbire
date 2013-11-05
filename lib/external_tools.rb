class ExternalTools

  def self.notifier(message)
    case RUBY_PLATFORM
    when /darwin/
      "terminal-notifier -sender com.apple.Terminal -message #{message}"
    when /linux/
      "notify-send '#{message}'"
    when /win32/
      raise NotImplementedError
    end
  end

  def self.recorder(path)
    case RUBY_PLATFORM
    when /darwin/
      "sox -t coreaudio -r 22050 default #{path} -q silence 1 0.1 0.5% 1 1.0 0.5% : newfile : restart"
    when /linux/
      "ffmpeg -loglevel panic -f alsa -ac 2 -i pulse -y #{path} -r 22050 >/dev/null 2>&1"
    when /win32/
      raise NotImplementedError
    end
  end

end
