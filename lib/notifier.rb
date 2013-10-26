class Notifier
  def self.call(message)
    system("notify-send '#{message}'")
  end
end
