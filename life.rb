class Board
  attr_accessor :width, :height, :size, :cells

  def initialize(width, height)
    self.width   = width
    self.height  = height
    self.size    = width * height
    self.cells   = Array.new(size) { false }
  end

  def alive?(x, y)
    cells[x * width + y]
  end

  def life_factor(x, y)
    [
      [x - 1, y - 1],
      [x,     y - 1],
      [x + 1, y - 1],
      [x - 1, y    ],
      [x + 1, y    ],
      [x - 1, y + 1],
      [x    , y + 1],
      [x + 1, y + 1]
    ].count do |nx, ny|
      alive?(nx, ny)
    end
  end

  def kill!(x, y)
    cells[x * width + y] = false
  end

  def spawn!(x, y)
    cells[x * width + y] = true
  end

  def each_cell_with_position
    (0...height).each do |x|
      (0...width).each do |y|
        yield alive?(x, y), x, y
      end
    end
  end
end

class Game
  attr_accessor :board

  def initialize(width = 20, height = 20)
    self.board = Board.new(width, height)
  end

  def randomize(percent = 0.25)
    (board.size * percent).to_i.times do
      board.spawn!(rand(board.width), rand(board.height))
    end
  end

  def evolve
    new_board = board.dup
    board.each_cell_with_position do |alive, x, y|
      life_factor = board.life_factor(x, y)
      if alive && (life_factor < 2 || life_factor > 3)
        new_board.kill!(x, y)
      elsif !alive && life_factor == 3
        new_board.spawn!(x, y)
      end
    end
    self.board = new_board
  end

  def print_board
    board.each_cell_with_position do |alive, x, y|
      print alive ? " O " : " . "
      print "\n" if y == (board.width - 1)
    end
  end
end

game = Game.new(40, 25)
game.randomize

loop do
  game.print_board
  game.evolve
  sleep 0.1
  system("clear")
end