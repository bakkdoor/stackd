module Primitives
  module Syntax
    def get_current_module(scope)
      mod_name = scope["*module_name*"]
      if mod_name
        scope[mod_name]
      else
        nil
      end
    end

    def init_primitive_syntax
      syntax('require:') do |scope, atoms|
        filename = atoms.first.eval(scope)
        filename += ".stackd" unless filename.end_with?(".stackd")
        Stackd.parse_eval_file(filename, scope)
      end

      syntax(':') do |scope, atoms|
        first = atoms.first
        case first
        when Stackd::Identifier
          mod = get_current_module(scope)
          if mod
            mod.define_word(first.text_value, atoms[1..-1])
          else
            scope.define_word(first.text_value, atoms[1..-1])
          end
        end
      end

      syntax('tuple:') do |scope, atoms|
        tuplename = atoms.first.text_value
        slots = atoms.rest.map{|a| a.text_value}
        case atoms.first
        when Stackd::Identifier
          mod = get_current_module(scope)
          if mod
            mod.define_tuple(tuplename, slots)
          else
            scope.define_tuple(tuplename, slots)
          end
        end
      end

      syntax('in:') do |scope, atoms|
        module_name = atoms.first.text_value
        scope["*modules*"] << module_name
        scope["*module_name*"] = module_name
        scope[module_name] = Scope.new(scope)
      end

      syntax('use:') do |scope, atoms|
        atoms.each do |a|
          module_name = a.text_value
          file = module_name.gsub(".", "/") + ".stackd"
          scope["*module_name*"] = module_name
          Stackd.parse_eval_file(file, scope)
        end
      end
    end
  end
end
