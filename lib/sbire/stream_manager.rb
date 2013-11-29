module Sbire
  class StreamManager
    attr_accessor :last_index, :max_index

    def initialize
      @last_index = 0
      @max_index = 0
    end

    def execute(hypotheses, index, &block)
      compute_max_index(index)
      hypotheses = current_hypotheses(hypotheses)
      unless hypotheses.include?(nil)
        send_result(hypotheses, block)
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

    def send_result(hypotheses, block)
      text = sanitize(hypotheses.join(" ")) + " "
      block.call(text) if text != " "
    end

    def sanitize(text)
      text.gsub('"', '\"')
    end
  end
end
