require "./spec_helper.rb"
require "./main.rb"

RSpec.describe Board do
  context "Main" do
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

    let(:ships) do
      [horizontal_ship, vertical_ship]
    end

    let(:board) do 
      board = described_class.new(width: 10, length: 10)
      board.add_ships(ships)

      board
    end

    # deprioritise validation style tasks...
    it "detects overlapping ships"
    it "detects out of bounds ships"

    it "detects winner" do
      expect {
        for x in (0..board.width) do
          for y in (0..board.length) do
            board.fire(x: x, y: y)
          end
        end
      }.to change { board.all_battleships_sunk? }
      .from(false).to(true)
    end

    it "can fire on correct ship"
  end

  context "Helpers" do
    let(:h) { described_class::H }
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

  it "converts vertical ship to points" do
    expected_points = [
      [3, 6],
      [3, 7],
    ].to_set

    expect(vertical_ship.to_points.to_set).to eq expected_points
    expect(vertical_ship.to_points.size).to eq vertical_ship.length 
  end

  it "converts horizontal ship to points" do
    expected_points = [
      [0, 0],
      [1, 0],
      [2, 0],
    ].to_set

    expect(horizontal_ship.to_points.to_set).to eq expected_points
    expect(horizontal_ship.to_points.size).to eq horizontal_ship.length 
  end
end
