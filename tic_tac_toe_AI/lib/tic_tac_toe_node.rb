require_relative 'tic_tac_toe'
class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if @board.winner # => :o || :x if winner nil if no winner
      return @board.winner != evaluator
    end
    children.any? do |child| #check for future moves
      child.losing_node?(evaluator)
    end
  end

  def winning_node?(evaluator)
    if @board.winner # => :o || :x if winner nil if no winner
      return @board.winner == evaluator
    end
    children.any? do |child| #check for future moves
      child.winning_node?(evaluator)
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    child_nodes = []
    @board.rows.each_with_index do |row, i|
      row.each_with_index do |ele, j|
        unless ele #creates child node if the ele is nil
          board_copy = @board.dup #copies board instance for child
          next_next = (next_mover_mark == :x ? :o : :x) #switches next player
          board_copy[[i, j]] = next_mover_mark #makes next move for child
          move_pos = [i,j] #sets previous_move_pos for child
          child = TicTacToeNode.new(board_copy, next_next, move_pos)
          child_nodes << child 
        end
      end 
    end
    child_nodes
  end
end
