class PidManager
  def store(object, pid)
    class_name = object.class.name
    File.open("/tmp/#{class_name}.pid", 'w') {|file| file.write(pid)}
  end

  def kill(object)
    class_name = object.class.name
    pid = File.read("/tmp/#{class_name}.pid")
    system("kill #{pid}")
  end
end
