require_relative 'tree_node.rb'
require 'byebug'

class KnightPathFinder
    KNIFHT_MOVES = [
    [1,2],
    [-1,2],
    [1, -2],
    [-1, -2],
    [2, 1],
    [-2, 1],
    [2, -1],
    [-2, -1]
]

    def initialize(start_pos)
        @start_pos = start_pos
        @root = PolyTreeNode.new(@start_pos)
        @considered_positions = [start_pos]
        
    end
    
    def self.valid_moves(pos) #calculates ALL valid moves
        pos_moves = []

        KNIFHT_MOVES.each do |position|
            x1,y1 = pos
            x2,y2 = position[0] + x1, position[1] + y1     
            if KnightPathFinder.valid_pos?([x2,y2])
                pos_moves << [x2,y2]
            end
        end

        pos_moves
    end

    def self.valid_pos?(pos)#checks if pos is on board
        pos.all? {|inx| inx >= 0 && inx < 8}
    end

    def new_move_positions(pos) #reject anything included in considered positions
        new_positions = []
        KnightPathFinder.valid_moves(pos).each do |pos|       
            unless @considered_positions.include?(pos)
                new_positions << pos
                @considered_positions << pos
            end
        end
        new_positions
    end

    def build_move_tree #remove argument
        queue = [@root]
        until queue.empty?
            first = queue.shift
            possible_moves = new_move_positions(first.value)
            possible_moves.each do |possible_move|
                child = PolyTreeNode.new(possible_move)
                first.add_child(child)
                queue << child
            end
        end
    end

    def find_path(end_pos) # => [[0,0],[1,2][0,2]]
        build_move_tree
        end_node = @root.dfs(end_pos) # => returns PolyTreeNode(end_pos)
        trace_path_back(end_node)
    end

    #helper method for #find_path
    def trace_path_back(end_node) # => [[0,0],[1,2][0,2]]
        path = []
        current_element = end_node
        until current_element.nil?
            path << current_element.value
            current_element = current_element.parent
        end
        path.reverse
    end
end
# [[[0,0], [1,2], [0,2]], longer_path1, longer_path2]
# knight = KnightPathFinder.new([0,0])
# knight.considered_positions # => [[0,0]]
# KnightPathFinder.valid_moves([0,0]) # => [[1,2],[2,1]]
# KnightPathFinder.valid_pos?([0,-1]) # => false
# new_move_positions([2, 1]) # => [[0,5],[3,0],[4,1],[4,3]]
# kpf.find_path([2, 1]) # => [[0, 0], [2, 1]]
# kpf.find_path([3, 3]) # => [[0, 0], [2, 1], [3, 3]]
# knight = KnightPathFinder.new([0,0])
# p knight.bfs([0,2])
# p knight.bfs([4,4])
# kpf = KnightPathFinder.new([0, 0])
# p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
# kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]