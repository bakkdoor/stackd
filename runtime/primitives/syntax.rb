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

      # define tuple
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

      # define generic method
      syntax('generic:') do |scope, atoms|
        methodname = atoms.first
#        stackeffect_declaration = atoms.rest.first
#        inputs = stackeffect_declaration.inputs
#        outputs = stackeffect_declaration.outputs
        if methodname.is_a?(Stackd::Identifier)
          mod = get_current_module(scope)
          if mod
            mod.define_generic(methodname.text_value,0,0) #, inputs.length, outputs.length)
          else
            scope.define_generic(methodname.text_value,0,0) #, inputs.length, outputs.length)
          end
        else
          raise "Generic method needs to be a correct identifier!"
        end
      end

      # define generic method implementation
      syntax('m:') do |scope, atoms|
        first = atoms.first
        case first
        when Stackd::Identifier
          mod = get_current_module(scope)
          if mod
            scope = mod
          end
          tuple = scope[first.text_value]
          if tuple.is_a?(Tuple)
            generic_word_name = atoms[1].text_value
            body = atoms[2..-1]
            GenericMethod.new(scope, tuple, generic_word_name, body)
          else
            raise Exception.new("Unknown tuple: #{atoms.first.text_value}")
          end
        end
      end

      # module declaration
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
