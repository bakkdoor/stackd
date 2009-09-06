class Word
  def initialize(scope, body = nil, &block)
    @scope = scope
    @body = body || block
  end

  def call(scope)
    return @body.call() if primitive?
    @body.each { |expr| expr.eval(@scope) }
  end

  def primitive?
    Proc === @body
  end

  def to_s
    "#<Word>"
  end

  def inspect
    to_s
  end
end

class Syntax < Word
  def call(scope, args)
    @body.call(scope, args)
  end

  def to_s
    "#<Syntax>"
  end

  def inspect
    to_s
  end
end

class GenericWord < Word
  attr_reader :name, :amount_inputs, :amount_outputs, :implementations
  def initialize(name, scope, amount_inputs, amount_outputs)
    super(scope, nil)
    @name = name
    @amount_inputs = amount_inputs
    @amount_outputs = amount_outputs
    @implementations = {} # Hash with tuples as keys
  end

  def call(scope)
    obj = DS.peek # last element (top of stack) is our dispatch object
    if obj.is_a?(TupleInstance) # only call generic words on tuple instances
      impl = @implementations[obj.tuple]
      if impl
        impl.call(scope)
      else
        raise NoMethodError.new("No generic method implementation of '#{@name}' for #{obj.tuple.name}.")
      end
    else
      raise Exception.new("Only can call generic method '#{@name}' for tuple instances.")
    end
  end

  def add_implementation(generic_method)
    @implementations[generic_method.tuple] = generic_method
  end

  def to_s
    "#<GenericWord:#{@name}>"
  end

  def inspect
    to_s
  end

  def self.find(scope, generic_word_name)
    scope.generics[generic_word_name]
  end
end

class GenericMethod < Word
  attr_reader :tuple, :generic_word_name
  def initialize(scope, tuple, generic_word_name, body)
    super(scope, body)
    @tuple = tuple
    @generic_word_name = generic_word_name

    generic_word = GenericWord.find(scope, generic_word_name)
    if generic_word
      generic_word.add_implementation(self)
    else
      raise Exception.new("Generic word not defined: '#{generic_word_name}'.")
    end
  end

  def to_s
    "#<GenericMethod:[#{@generic_word_name}/#{@tuple.name}]"
  end
end
