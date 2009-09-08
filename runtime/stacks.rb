class StackUnderflowError < Exception
end

module StackdStack
  def <<(elem)
    values.push(elem) unless elem.nil?
  end

  def check_empty(amount_needed)
    diff = amount_needed - values.length
    if diff > 0
      msg = "Expected #{diff} more elements on the stack."
      raise StackUnderflowError.new(msg)
    end
  end

  def pop
    values.pop()
  end

  def peek
    values.last
  end

  def size
    values.size
  end

  def take(n)
    check_empty(n)
    vals = values.slice!((values.length - n), values.length)
    vals.reverse
  end

  def with_args(n, &block)
    args = self.take(n).reverse
    self << block.call(*args)
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
