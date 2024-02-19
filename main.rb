# know
# - 10x10 board on which ships can be placed
# - ships can be vertical or horizontal lines of width 1
# - ships must fit on board and cannot overlap
# - a ship is sunk if all its points have been hit
# - battleships are present at beginning of game
# - a game has two boards (one per player)
# - ships cannot overlap:
# - - all ship points are unique
# - - aha can easily lookup ship by point

# maybe - hash of points to ships
# - each ship could have point collection used for lookup when firing
# - hash of points -> ship enables quick firing
# - ship itself keeps of track of firing
# - ship can indicate when it is sunk
# { Point(x: 1, y: 1) => ship_1 }
# hash[Point.new(x: 1, y: 1)]&.fire(1, 1) ? 'hit' : 'miss'
# reflect - data structure idea emerged from investigation, not plucked.
# know - this allows quick firing, 
# win detection would be iterating over ships and checking sunk?
# adding a ship is fairly easy:
# - convert to point collection and update hash
# - easy overlap detection this way too!

# introduce: example session
# board = Board.new(width: 10, height: 10)
# board.add_ships([ship_1, ship_2])
# board.fire(x: 1, y: 1) --> boolean
# board.all_battleships_sunk? --> boolean
# board is responsible for:
# - win detection (check if all are sunk)
# - overlap prevention (check all points unique)
# - check all ships are within board (coordinate validation)
# - delegating firing (lookup ship by coordinate)

# introduce: ship model
# ship_1 = BattleShip.new(x: 1, y: 1, length: 5, orientation: 'horizontal')
# ship_2 = BattleShip.new(x: 1, y: 2, length: 2, orientation: 'vertical')
# ship_1_points = ship_1.to_points -> [Point.new(x: 1, y:1), ...]
# ship_1.fire(1, 1) --> boolean
# ship_1.sunk? --> boolean
# ship is responsible for:
# - generating point collection
# - tracking fire hits
# - checking if sunk

# reflect - uncertainty growing, progress slowing, 
# perhaps try something to learn more

BattleShip = Data.define(:x, :y, :length, :orientation) do
  def initialize(x:, y:, length:, orientation:)
    @points = {}

    if orientation == 'horizontal'
      for x in (x...(x + length))
        @points[[x, y]] = false
      end
    else
      for y in (y...(y + length))
        @points[[x, y]] = false
      end
    end

    super(x: x, y: x, length: length, orientation: orientation)
  end

  def fire(x:, y:)
    if @points[[x, y]].nil?
      false
    else
      @points[[x, y]] = true
      true
    end
  end

  def sunk?
    @points.values.all? { |v| v == true }
  end

  def to_points
    @points.keys
  end
end

class Board
  attr_accessor :width, :length

  def initialize(width:, length:)
    @width = width
    @length = length

    @points_to_ships = {}
  end

  def add_ships(ships)
    for ship in ships
      for point in ship.to_points
        if @points_to_ships[point].nil?
          @points_to_ships[point] = ship
        else
          raise "Overlapping ships"
        end
      end
    end

    nil
  end

  def fire(x:, y:)
    @points_to_ships[[x, y]]&.fire(x: x, y: y) || false
  end

  def all_battleships_sunk?
    @points_to_ships.values.all? { |ship| ship.sunk? }
  end

  class Helpers
    class << self
    end
  end

  H = Helpers
end