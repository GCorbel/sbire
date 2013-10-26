class CommandManager
  attr_accessor :hypotheses

  def initialize(hypotheses)
    @hypotheses = hypotheses
  end

  def execute
    command = find(hypotheses)
    system("#{command} &")
    return command
  end

  private
  def find(hypotheses)
    hypotheses.first.downcase
  end
end
