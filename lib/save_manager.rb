class SaveManager
  attr_accessor :hypotheses

  def initialize(hypotheses)
    @hypotheses = hypotheses
  end

  def save
    File.open(SbireConfig.text_file, 'w') {|file| file.write(hypotheses.first)}
  end
end
