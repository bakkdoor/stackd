class Scope
  def initialize(parent = nil)
    @parent = parent || {}
    @symbols = {}
    @tuples = {}
  end

  def tuples
    @tuples
  end

  def [](name)
    @symbols[name] || @parent[name]
  end

  def []=(name, value)
    @symbols[name] = value
  end

  def with_args(n, &block)
    args = DS.take(n).reverse
    DS << block.call(*args)
  end

  def define_word(name, *body, &block)
    self[name] = Word.new(self, *body, &block)
  end

  def syntax(name, &block)
    self[name] = Syntax.new(self, &block)
  end

  def define_tuple(name, slots)
    tuple = Tuple.new(name, slots)
    self.tuples[name] = tuple
    define_slot_accessors(slots)
    self[name] = tuple
  end

  def define_slot_accessors(slots)
    # define slot accessors
    slots.each do |s|
      # getter
      define_word("#{s}>>"){
        with_args(1) { |instance|
          instance.send(s)
        }
      }

      # setter
      define_word(">>#{s}"){
        with_args(2){ |instance, val|
          instance.send("#{s}=", val)
          DS << instance
          nil
        }
      }
    end
  end
end

class TopLevel < Scope
  include Primitives::Syntax
  include Primitives::Words
  def initialize(*args)
    super

    init_primitive_syntax
    init_primitive_functions

    # define standard modules
    self["Kernel"] = Kernel
    self["STDIN"] = STDIN
    self["Math"] = Math
    self["PP"] = PP
    self["$$"] = DS.values # datastack accessor
    self["*modules*"] = [] # loaded module list accessor
    self["$!"] = self # global scope accessor
  end
end

