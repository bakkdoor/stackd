class Tuple
  attr_reader :slots, :name
  def initialize(name, slots)
    @name = name
    @slots = slots || []
    @instances = []
  end

  def to_s
    "#<Tuple:#{@name} [#{@slots.join(',')}]>"
  end

  def inspect
    to_s
  end

  def create_instance
    instance = TupleInstance.new(self)
    @instances << instance
    instance
  end
end

class TupleInstance
  attr_reader :tuple, :slots
  def initialize(tuple)
    @tuple = tuple
    @slots = tuple.slots
    self.class.instance_eval{ attr_accessor *tuple.slots }
  end

  def inspect
    to_s
  end

  def to_s
    slot_val_string = @slots.collect{|s| "@#{s}=#{self.send(s)}"}.join(", ")
    "#<TupleInstance:#{@tuple.name} @slots=#{@slots.inspect}, #{slot_val_string}>"
  end
end
