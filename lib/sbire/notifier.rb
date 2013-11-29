module Sbire
  class Notifier
    def self.call(message)
      command = SbireConfig.notify_command % { message: message }
      system(command)
    end
  end
end
