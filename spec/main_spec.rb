require './spec_helper.rb'
require './main.rb'

RSpec.describe Main do
  context "Setup" do
    it "exists" do
      expect(described_class).to_not be_nil
    end

    it "has an instance method" do
      expect(described_class.new.hello).to eq 'hello'
    end
  end

  context "Helpers" do
    it "has a static helper" do
      expect(described_class::Helpers.say_hello).to eq 'hello'
    end
  end
end