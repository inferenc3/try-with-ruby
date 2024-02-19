require "./spec_helper.rb"
require "./main.rb"

RSpec.describe Main do
  context "Main" do
    let(:instance) { described_class.new }

    it "exists" do
      expect(described_class).to_not be_nil
    end

    it "has an instance method" do
      expect(instance.hello).to eq "hello"
    end
  end

  context "Helpers" do
    let(:h) { described_class::H }

    it "has a static helper" do
      expect(h.say_hello).to eq "hello"
    end
  end
end
