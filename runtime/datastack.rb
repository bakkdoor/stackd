class StackUnderflowError < Exception
end

module StackdStack
  def <<(elem)
    values.push(elem) unless elem.nil?
  end

  def check_empty(amount_needed = nil)
    if values.empty?
      msg = if amount_needed
              "Expected #{amount_needed} more elements on the stack."
            else
              "Stack is empty."
            end
      raise StackUnderflowError.new(msg)
    end
  end

  def pop
    values.pop()
  end

  def size
    values.size
  end

  def take(n)
    vals = []
    n.times{ |i|
      check_empty(n-i)
      vals << values.pop
    }
    vals
  end

  def clear
    values.clear
  end

  def inspect
    values.inspect
  end
end

# data stack
class DS
  extend StackdStack
  @@elements = []
  def self.values
    @@elements
  end
end

# retain stack
class RS
  extend StackdStack
  @@elements = []
  def self.values
    @@elements
  end
end
