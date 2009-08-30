module Primitives
  module Syntax
    def init_primitive_syntax
      syntax('require:') do |scope, cells|
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
    end
  end
end
