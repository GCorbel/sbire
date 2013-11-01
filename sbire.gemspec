Gem::Specification.new do |s|
  s.name        = 'sbire'
  s.version     = '0.0.3'
  s.date        = Date.today
  s.summary     = "The henchman who do what you say"
  s.description = "Sbire is a command line tool that recognize your voice and execute commands linked"
  s.homepage    = "https://github.com/GCorbel/sbire"
  s.authors     = ["Guirec Corbel"]
  s.email       = 'guirec.corbel@gmail.com'
  s.files       = Dir.glob("{bin,lib}/*") + %w(README.md)
  s.executables = ['sbire']
  s.license     = 'MIT'

  s.add_runtime_dependency 'curb'
  s.add_runtime_dependency 'speech2text'
end
