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
          scope[first.text_value] = cells[1].eval(scope)
        end
      end

      syntax('define-macro') do |scope, cells|
        name_and_args = cells.first
        case name_and_args # this is the name & argument list of the macro
        when Lisp::List
          names = name_and_args.cells#.map { |c| c.text_value }
          macro_name = names.first
          args = names.rest
          macro_body = cells[1..-1]

          scope[macro_name.text_value] = Macro.new(scope, args, macro_body)
        end

          # macro_body[1].cells.collect do |cell|
          #   if cell.text_value =~ /^,/
          #     names.each do |name|
          #       if cell.text_value == ",#{name.text_value}"
          #         name.eval(scope)
          #       end
          #     end
          #   end
          # end

          # syntax(macro_name) do |scope, cells|
          # end

#          if args.include?("&body")
            # we're looking for the value after &body
#            idx = args.index("&body") + 1
#          end
#        end
      end

      syntax('lambda') do |scope, cells|
        names = cells.first.cells.map { |c| c.text_value }
        Function.new(scope, names, cells[1..-1])
      end

      syntax('progn') do |scope, cells|
        Function.new(scope, [], cells).call(scope, [])
      end

      syntax('if') do |scope, cells|
        puts "OK>>>>>>"
        which = cells.first.eval(scope) ? cells[1] : cells[2]
        which.eval(scope)
      end

      syntax('unless') do |scope, cells|
        which = cells.first.eval(scope) ? cells[2] : cells[1]
        which.eval(scope)
      end

      syntax('let') do |scope, cells|
        first = cells.first
        case first
        when Lisp::List
          names = first.cells.map{ |pair| pair.cells.first.text_value }
          values = first.cells.map{ |pair| pair.cells[1] }
          Function.new(scope, names, cells[1..-1]).call(scope, values)
        end
      end

      syntax('let*') do |scope, cells|
        first = cells.first
        case first
        when Lisp::List
          names = first.cells.map{ |pair| pair.cells.first.text_value }
          values = first.cells.map{ |pair| pair.cells[1] }

          let_scope = Scope.new(scope)
          values.each_with_index do |val, i|
            let_scope[names[i]] = val.eval(let_scope)
          end

          Function.new(scope, names, cells[1..-1]).call(let_scope, values)
        end
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
