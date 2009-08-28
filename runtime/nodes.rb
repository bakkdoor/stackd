module Stackd
  class Program < Treetop::Runtime::SyntaxNode
    def eval(scope)
      elements.map { |e| e.eval(scope) if e.respond_to?(:eval) }.last
    end
  end

  class Expression < Treetop::Runtime::SyntaxNode
    def eval(scope)
      func = atoms.first.eval(scope)
      args = atoms[1..-1]

      if func.is_a?(Function)
        func.call(scope, args)
      elsif func.is_a?(Macro)
        func.call(scope, args)
#      elsif func.is_a?(Datum)
#        puts "is a datum!"
      else
        name = atoms.first.eval(scope) || atoms.first.text_value
        puts "Unkown function: '#{name}' isn't defined!"
        exit
      end
    end

    def atoms
      elements[1].elements.map { |c| c.data }
    end
  end

  class WordDefinition < Treetop::Runtime::SyntaxNode
    def eval(scope)
      puts "OK"
    end
  end

  class Comment < Treetop::Runtime::SyntaxNode
    def eval(scope); nil; end
  end

  class Atom < Treetop::Runtime::SyntaxNode
    def eval(scope); data.eval(scope); end
    def data; elements[1]; end
  end

  module Boolean
    def eval(scope); DS << (text_value == '#t'); end
  end

  module Integer
    def eval(scope); DS << text_value.to_i; end
  end

  class Identifier < Treetop::Runtime::SyntaxNode
    def eval(scope); scope[text_value]; end
  end

  class Float
    def eval(scope); DS << text_value.to_f; end
  end

  class LispString < Treetop::Runtime::SyntaxNode
    def eval(scope)
      DS << (string_val.elements.collect{ |e|
        e.char.text_value
      }.join(""))
    end
  end
end

class Array
  def rest
    self[1..-1] || []
  end
end
