class SaveManager
  attr_accessor :hypotheses

  def initialize(hypotheses)
    @hypotheses = hypotheses
  end

  def save
    File.open(Sbire::TEXT_FILE, 'w') {|file| file.write(hypotheses.first)}
  end
end
