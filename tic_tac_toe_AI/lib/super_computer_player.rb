require_relative 'tic_tac_toe_node'

class SuperComputerPlayer
  attr_reader :name
  def initialize
    @name = "Hal9000"
  end

  def move(game, mark) #returns a pos
    move = nil
    super_game = TicTacToeNode.new(game.board, mark)

    #accounts for winning potential move
    super_game.children.each do |child|
      if child.winning_node?(mark) 
        unless child.losing_node?(mark)
          return child.prev_move_pos
        end
      end  
    end

    #accounts for non-losing moves
    super_game.children.each do |child|
      #picks a move that has no lose potential
      unless child.losing_node?(mark)
        return child.prev_move_pos
      end
    end

    #makes an array of moves that could lead to an immediate loss
    possible_moves = []
    game.board.rows.each_with_index do |row,idx|
      row.each_with_index do |el,idx2|
        if el == nil
          possible_moves << [idx,idx2]
        end
      end
    end

    #selects all potential winning moves
    winning_moves = possible_moves.select do |pos|
      board_copy = game.board.dup
      next_mark = (mark == :x ? :o : :x)
      board_copy[pos] = next_mark
      board_copy.winner == next_mark #[idx, idx2]
    end

    return winning_moves.first if winning_moves.length == 1

    raise "wtf??"
  end
end

# p __FILE__
# p $PROGRAM_NAME

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
