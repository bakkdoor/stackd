module StackdStack
  def <<(elem)
    values.push(elem) unless elem.nil?
  end

  def >>()
    values.pop()
  end

  def pop
    values.pop()
  end

  def size
    values.size
  end

  def take(n)
    vals = []
    n.times{ vals << values.pop }
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
