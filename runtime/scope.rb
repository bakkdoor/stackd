class Scope
  def initialize(parent = nil)
    @parent = parent || {}
    @symbols = {}
  end

  def [](name)
    @symbols[name] || @parent[name]
  end

  def []=(name, value)
    @symbols[name] = value
  end

  def define(name, *args, &block)
    self[name] = Function.new(self, *args, &block)
  end

  def syntax(name, &block)
    self[name] = Syntax.new(self, &block)
  end
end

class TopLevel < Scope
  include Primitives::Syntax
  include Primitives::Functions
  def initialize(*args)
    super

    init_primitive_syntax
    init_primitive_functions

    # define standard modules
    self["Kernel"] = Kernel
    self["PP"] = PP
  end
end

