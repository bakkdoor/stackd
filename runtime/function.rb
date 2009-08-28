class Function
  def initialize(scope, formals = [], body = nil, &block)
    @scope = scope
    @formals = formals.map { |f| f.to_s }
    @body = body || block
  end

  def call(scope, args)
    args = args.map { |a| a.respond_to?(:eval) ? a.eval(scope) : a }
    return @body.call(*args) if primitive?
    closure = Scope.new(@scope)
    @formals.each_with_index { |name, i| closure[name] = args[i] }
    @body.map { |expr| expr.eval(closure) }.last
  end

  def primitive?
    Proc === @body
  end
end

class Macro
  def initialize(scope, formals = [], body = nil)
    @scope = scope
    @formals = formals.map { |f| f.text_value }
    @body = body
  end

  def call(scope, args)
    # args = args.map { |a| puts a.eval(scope); a.respond_to?(:eval) ? a.eval(scope) : a}
    closure = Scope.new(@scope)
    @formals.each_with_index{ |name, i| closure[name] = args[i] }

    # need to do deep replacement (inner nodes as well ...)
    replaced_body = @body[0].cells.collect do |cell|
      if cell.text_value =~ /^,/
        val = cell
        @formals.each_with_index do |f, i|
          if cell.text_value == ",#{f}"
            val = closure[f]
          end
        end
        val
      else
        cell
      end
    end
    #    pp replaced_body
    # TODO: fix this here!!
    func_body = [Lisp::List.new(replaced_body.flatten, nil)]
    pp func_body
    Function.new(@scope, [], func_body).call(closure, [])
  end
end

class Syntax < Function
  def call(scope, args)
    @body.call(scope, args)
  end
end

