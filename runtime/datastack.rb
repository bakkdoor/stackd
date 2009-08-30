class DS
  @@elements = []

  def self.values
    @@elements
  end

  def self.<<(elem)
    @@elements.push(elem)
  end

  def self.>>()
    @@elements.pop()
  end

  def self.size
    @@elements.size
  end

  def self.take(n)
    vals = []
    n.times{ vals << @@elements.pop }
    vals
  end

  def self.inspect
    @@elements.inspect
  end
end
