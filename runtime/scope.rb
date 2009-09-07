class Scope
  def initialize(parent = nil)
    @parent = parent || {}
    @symbols = {}
    @tuples = {}
    @generics = {}
  end

  def tuples
    @tuples
  end

  def generics
    @generics
  end

  def [](name)
    @symbols[name] || @parent[name]
  end

  def []=(name, value)
    @symbols[name] = value
  end

  def with_args(n, &block)
    DS.with_args(n, &block)
  end

  def define_word(name, *body, &block)
    self[name] = Word.new(self, *body, &block)
  end

  def syntax(name, &block)
    self[name] = Syntax.new(self, &block)
  end

  def define_tuple(name, slots, superclass = nil)
    tuple = Tuple.new(name, slots, superclass)
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

  def define_generic(name, amount_inputs, amount_outputs)
    gen_word = GenericWord.new(name, self, amount_inputs, amount_outputs)
    self.generics[name] = gen_word
    self[name] = gen_word
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
