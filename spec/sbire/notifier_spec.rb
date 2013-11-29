require 'spec_helper'
require 'sbire/notifier.rb'

module Sbire
  describe Notifier do
    describe ".call" do
      it "send a message" do
        allow(SbireConfig).to receive(:notify_command).
          and_return("notifier '%{message}'")
        expect(Notifier).to receive(:system).with("notifier 'a message'")
        Notifier.call('a message')
      end
    end
  end
end
