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
end

