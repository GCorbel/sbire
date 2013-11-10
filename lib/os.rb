class OS
  def self.familly
    return "win" if OS.windows?
    return "linux" if OS.unix? || OS.linux?
    return "mac" if OS.mac?
  end

  def self.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def self.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def self.unix?
    !OS.windows?
  end

  def self.linux?
    OS.unix? and not OS.mac?
  end
end
