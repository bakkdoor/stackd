module Primitives
  module Words
    def with_args(n, &block)
      args = DS.take(n).reverse
      DS << block.call(*args)
    end

    def init_primitive_functions
      define_word('ruby-require') { |name| require(name) }

      define_word('+') { with_args(2){ |a1,a2| a1 + a2 } }
      define_word('-') { with_args(2){ |a1,a2| a1 - a2 } }
      define_word('*') { with_args(2){ |a1,a2| a1 * a2 } }
      define_word('/') { with_args(2){ |a1,a2| a1 / a2 } }
      define_word('mod') { with_args(2) { |n,m| n.modulo(m) } }
      define_word('=') { with_args(2){ |a1,a2| a1 == a2 } }
      define_word('<=') { with_args(2){ |a1,a2| a1 <= a2 } }
      define_word('>=') { with_args(2){ |a1,a2| a1 >= a2 } }
      define_word('and') { with_args(2){ |a1,a2| a1 && a2 } }
      define_word('or') { with_args(2){ |a1,a2| a1 || a2 } }
      define_word('not'){ with_args(1){ |a1| not a1 } }

      define_word('print') { with_args(1) { |x| puts x } }
      define_word('print-'){ with_args(1) { |x| print x } }

      #define_word('callm') { |methodname, object, *args| object.send(methodname.to_sym, *args) }

      define_word('first') { with_args(1) { |list| list.first } }
      define_word('rest') { with_args(1) { |list| list[1..-1] } }
      define_word('nth') { with_args(2) { |n,list| list[n] } }
      define_word('empty?') { with_args(1) { |list| list.empty? } }
      define_word('nil?') { with_args(1) { |obj| obj.nil? } }
      define_word('map') {
        with_args(2) { |list, quot|
          amount = list.length
          newlist = []
          amount.times do |i|
            DS << list[i]
            quot.call(self)
            newlist << DS.pop
          end
          amount.times{ DS.pop }
          DS << newlist
          nil
        }
      }
      define_word('each') {
        with_args(2){ |list, quot|
          list.each{ |x| DS << x; quot.call(self) }
          nil
        }
      }

      define_word('dup'){ DS << DS.values.last }
      define_word('swap'){ with_args(2){ |a,b| DS << b; DS << a; nil } }
      define_word('drop'){ DS.pop; nil }
      define_word('dip'){ with_args(2) { |x,quot| RS << x; quot.call(self); RS.pop } }
      define_word('keep'){ with_args(2) { |x,quot| RS << x; DS << x; quot.call(self); RS.pop } }

      define_word('inspect'){ with_args(1){ |a| a.inspect } }
      define_word('.'){ with_args(1){ |a| pp a } }

      define_word('clear') { DS.clear; nil }
      define_word('call') { with_args(1) { |quot| quot.call(self); nil } }
      define_word('if') {
        with_args(3) { |cond,then_quot,else_quot|
          (cond ? then_quot : else_quot).call(self)
          nil
        }
      }

      define_word('array<<'){ |list| Array.new(list) }
    end
  end
end
