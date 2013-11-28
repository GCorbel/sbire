require 'yaml'

module Sbire
  class CommandManager
    attr_accessor :commands

    def initialize(path)
      @commands = YAML.load_file(path) if File.exist?(path)
    end

    def execute(hypotheses, index)
      current_hypothese = hypotheses[index]
      unless current_hypothese.first.empty?
        command = find(current_hypothese)
        system("#{command} &")
        return command
      end
    end

    private
    def find(hypotheses)
      hypothese = hypotheses.first.downcase
      if commands
        commands.each_pair {|key, value| return key if value.include?(hypothese)}
      end
      return hypothese
    end
  end
end
