Gem::Specification.new do |s|
  s.name        = 'vocal_command'
  s.version     = '0.0.1'
  s.date        = Date.today
  s.summary     = "Voice recognition"
  s.authors     = ["Guirec Corbel"]
  s.email       = 'guirec.corbel@gmail.com'
  s.files       = Dir.glob("{bin,lib}/*") + %w(README.md)
  s.executables = ['vocal_command']
end
