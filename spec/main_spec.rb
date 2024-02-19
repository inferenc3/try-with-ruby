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

RSpec.describe BattleShip do
  let(:horizontal_ship) do
    BattleShip.new(
      x: 0,
      y: 0,
      length: 3,
      orientation: "horizontal",
    )
  end

  let(:vertical_ship) do
    BattleShip.new(
      x: 3,
      y: 6,
      length: 2,
      orientation: "vertical",
    )
  end

  it "reports hit or miss on horizontal ship" do
    expect(horizontal_ship.fire(x: 1, y: 0)).to eq true
    expect(horizontal_ship.fire(x: 1, y: 4)).to eq false
  end

  it "reports hit or miss on horizontal ship" do
    expect(vertical_ship.fire(x: 3, y: 6)).to eq true
    expect(vertical_ship.fire(x: 1, y: 1)).to eq false
  end

  it "reports whether sunk?" do
    vertical_ship.fire(x: 3, y: 6)
    vertical_ship.fire(x: 3, y: 7)
    vertical_ship.fire(x: 3, y: 8)

    expect(vertical_ship.sunk?).to eq true
  end

  fit "converts to points" do
    expected_points = [
      [3, 6],
      [3, 7],
      [3, 8],
    ].to_set

    expect(vertical_ship.to_points.to_set).to eq expected_points
  end
end
