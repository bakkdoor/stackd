module Stackd
  class Program < Treetop::Runtime::SyntaxNode
    def eval(scope)
      elements.map { |e| e.eval(scope) if e.respond_to?(:eval) }
    end
  end

  class Expression < Treetop::Runtime::SyntaxNode
    def eval(scope)
      # need to call each word in a row, pushing all non-words on
      # the stack while doing so :)
      # atoms.map{|a| a.eval(scope)}.last
      first = atoms.first.eval(scope)
      unless first.nil?
        if first.is_a?(Syntax)
          first.call(scope, atoms.rest)
        else
          atoms.rest.each{|a| a.eval(scope)}
        end
      end
    end

    def atoms
      elements[1].elements.map { |c| c.data unless c.is_a?(Comment) }.compact
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
    def eval(scope); DS << (text_value == 't'); end
  end

  module Integer
    def eval(scope); DS << text_value.to_i end
  end

  class Identifier < Treetop::Runtime::SyntaxNode
    def eval(scope)
      val = nil
      # handle special cases, like calling explicitly named words with
      # module name prefixed
      if text_value.include?("::")
        mod_name, word_name = text_value.split("::")
        val = scope[mod_name][word_name]
      else
        val = scope[text_value]
        unless val
          module_name = scope["*modules*"].find{ |mod| modval = scope[mod]; modval[text_value] if modval }
          if module_name
            val = scope[module_name][text_value]
          end
        end
      end
      if val
        if val.is_a?(Syntax)
          val
        else
          if val.respond_to?(:call)
            val.call(scope)
          else
            # must be a special / global variable
            DS << val
          end
        end
      else
        puts "Error: Unknown symbol: '#{text_value}'"
        exit
      end
    end
  end

  class Float
    def eval(scope); DS << text_value.to_f; end
  end

  class StackdString < Treetop::Runtime::SyntaxNode
    def eval(scope)
      DS << (string_val.elements.collect{ |e|
        e.char.text_value
      }.join(""))
    end
  end

  class Quotation < Treetop::Runtime::SyntaxNode
    def eval(scope)
      DS << Word.new(scope, atoms.elements)
    end
  end

  class Array < Treetop::Runtime::SyntaxNode
    def eval(scope)
      if self.text_value =~ /\[\s*\]/
        DS << Array.new
      else
        items.elements.collect{ |i| i.eval(scope) }.first
        arr = DS.take(items.elements.length).reverse
        DS << arr
      end
    end
  end

  class Hashtable < Treetop::Runtime::SyntaxNode
    def eval(scope)
      size_before = DS.values.length
      entries.elements.each do |ws_and_entry|
        ws_and_entry.entry.eval(scope)
      end
      size_after = DS.values.length
      diff = size_after - size_before
      # remove keys & vals from DS
      vals = DS.take(diff).reverse
      hash = Hash[*vals.flatten]
      # and save hash
      DS << hash
    end
  end

  class HashEntry < Treetop::Runtime::SyntaxNode
    def eval(scope)
      [key.eval(scope), val.eval(scope)]
    end
  end

  class Symbol < Treetop::Runtime::SyntaxNode
    def eval(scope)
      DS << symbol_name.text_value.to_sym
    end
  end

  class Regex < Treetop::Runtime::SyntaxNode
    def eval(scope)
      DS << Regexp.new(self.val.text_value)
    end
  end
end

class Array
  def rest
    self[1..-1] || []
  end

  def inspect
    "#(#{self.map{|x| x.inspect}.join(" ")})"
  end
end
