module Sbire
  class PidManager
    def store(object, pid)
      File.open("/tmp/#{class_name(object)}.pid", 'w') {|file| file.write(pid)}
    end

    def kill(object)
      if File.exists?("/tmp/#{class_name(object)}.pid")
        pid = File.read("/tmp/#{class_name(object)}.pid")
        system("kill #{pid}")
      end
    end

    private

    def class_name(object)
      object.class.name.split('::').last
    end
  end
end
