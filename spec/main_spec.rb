require './main.rb'

RSpec.describe Main do
  context "Setup" do
    it "exists" do
      expect(described_class).to_not be_nil
    end
  end
end