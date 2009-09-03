class Tuple
  def initialize(name, slots)
    @name = name
    @slots = slots || []
#    self.class.instance_eval{ attr_accessor *slots }
  end

  def to_s
    "#<Tuple:#{@name} [#{@slots.join(',')}]>"
  end

  def inspect
    to_s
  end
end
