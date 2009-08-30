module Primitives
  module Syntax
    def init_primitive_syntax
      syntax('require') do |scope, cells|
        filename = cells.first.eval(scope)
        filename += ".stackd" unless filename.end_with?(".stackd")
        Stackd.parse_eval_file(filename, scope)
      end

      syntax(':') do |scope, cells|
        first = cells.first
        case first
        when Stackd::Identifier
          scope.define_word(first.text_value, cells[1..-1])
        end
      end

      syntax('lambda') do |scope, cells|
        names = cells.first.cells.map { |c| c.text_value }
        Function.new(scope, names, cells[1..-1])
      end

      syntax('callm') do |scope, cells|
        methodname = cells.first.text_value
        obj = cells[1].eval(scope)
        args = cells[2..-1].map{ |c| c.eval(scope) }
        obj.send(methodname.to_sym, *args)
      end

      syntax('list') do |scope, cells|
        Array.new(cells.map{|x| x.eval(scope)})
      end

      syntax('set') do |scope, cells|
        name = cells.first.text_value
        value = cells[1].eval(scope)
        scope[name] = value
      end
    end
  end
end
