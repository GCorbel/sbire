require 'spec_helper'
require 'sbire/pid_manager'

module Sbire
  describe PidManager do
    describe "#store" do
      it "store the pid in a file with the class name" do
        class FirstClass; end
        subject.store(FirstClass.new, 1)
        expect(File.read("/tmp/FirstClass.pid")).to eq "1"

        class SecondClass; end
        subject.store(SecondClass.new, 2)
        expect(File.read("/tmp/SecondClass.pid")).to eq "2"
      end
    end

    describe "#kill" do
      it "read the pid of the give class" do
        class FirstClass; end
        File.open("/tmp/FirstClass.pid", 'w') {|file| file.write(1)}
        expect(subject).to receive(:system).with("kill 1")
        subject.kill(FirstClass.new)

        class SecondClass; end
        File.open("/tmp/SecondClass.pid", 'w') {|file| file.write(2)}
        expect(subject).to receive(:system).with("kill 2")
        subject.kill(SecondClass.new)
      end
    end
  end
end
