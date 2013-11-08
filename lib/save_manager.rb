class SaveManager
  attr_accessor :last_index, :max_index

  def initialize
    @last_index = 0
    @max_index = 0
  end

  def save(hypotheses, index)
    compute_max_index(index)
    hypotheses = current_hypotheses(hypotheses)
    unless hypotheses.include?(nil)
      append_to_file(hypotheses)
      @last_index = index + 1
    end
  end

  private

  def compute_max_index(index)
    @max_index = index if @max_index < index
  end

  def current_hypotheses(hypotheses)
    hypotheses.map { |hypothese| hypothese.first }[last_index..max_index]
  end

  def append_to_file(hypotheses)
    text = hypotheses.join(" ") + " "
    if text != " "
      File.open(SbireConfig.text_file, 'ab+') {|file| file.write(text)}
    end
  end
end
