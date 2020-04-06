require 'byebug'
class PolyTreeNode
    attr_accessor :children
    attr_reader :value, :parent

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def add_child(new_child)
        new_child.parent = self
    end

    def remove_child(child)
        if child.parent == nil
            raise "child has no parents! :("
        else
            child.parent = nil
        end
    end

    def parent=(new_parent) 
        if @parent
            @parent.children.delete(self) #removes self from parents children
        end
        
        if new_parent
            new_parent.children << self #adds self to new parent
        end
            
        @parent = new_parent
    end

    def dfs(target) #self starts as root// self = 'valua = a', children = [b,c],  
        # debugger
        return self if self.value == target #e == e
        return nil if @children.empty? # d => no
        # return nil if self.value != target

        @children.each do |child| #[e]
            search_result = child.dfs(target) #dfs(e)
            unless search_result.nil? # e
                return search_result if search_result.value == target # e
            end
        end

        nil
    end

    def bfs(target) #e
        queue = [self] #b, c
        until queue.empty?
            next_c = queue.shift #b
            return next_c if next_c.value == target #a != e
            next_c.children.each do |child| #queue [c,d]
                queue << child
            end
        end
        nil
    end

end

#    [a]
#  [b]  [c]
#[d][e][f][g]
# ("a")
