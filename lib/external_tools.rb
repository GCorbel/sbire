class ExternalTools

  def self.notifier(message)
    case RUBY_PLATFORM
    when /darwin/
      "terminal-notifier -sende com.apple.Terminal -message #{message}"
    when /linux/
      "notify-send '#{message}'"
    when /win32/
      raise NotImplementedError
    end
  end

  def self.recorder(path)
    case RUBY_PLATFORM
    when /darwin/
      "sox -r 22050 -d #{path} >/dev/null 2>&1"
    when /linux/
      "ffmpeg -loglevel panic -f alsa -ac 2 -i pulse -y #{path} -r 22050 >/dev/null 2>&1"
    when /win32/
      raise NotImplementedError
    end
  end

end
