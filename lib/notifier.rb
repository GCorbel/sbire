class Notifier
  def self.call(message)
    system("#{command} '#{message}'")
  end

  def self.command
    case RUBY_PLATFORM
    when /darwin/
      'terminal-notifier -sender com.apple.Terminal -message'
    when /linux/
      'notify-send'
    when /win32/
      raise NotImplementedError
    end
  end
end
