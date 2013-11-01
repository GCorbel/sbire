class Notifier
  def self.call(message)
    system("#{ExternalTools.notifier} '#{message}'")
  end
end
