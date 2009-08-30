class Word
  def initialize(scope, body = nil, &block)
    @scope = scope
    @body = body || block
  end

  def call(scope)
    # args = args.map { |a| a.respond_to?(:eval) ? a.eval(scope) : a }
    return @body.call() if primitive?
    closure = Scope.new(@scope)
    # @formals.each_with_index { |name, i| closure[name] = args[i] }
    @body.each { |expr| expr.eval(closure) }
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
end

