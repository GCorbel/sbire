class SaveManager
  attr_accessor :hypotheses

  def initialize(hypotheses)
    @hypotheses = hypotheses
  end

  def save
    File.open('result', 'w') {|file| file.write(hypotheses.first)}
  end
end
