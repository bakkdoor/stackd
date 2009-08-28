module Primitives
  module Functions
    def with_args(n, &block)
      args = DS.take(n)
      DS << block.call(*args)
    end

    def init_primitive_functions
      define('ruby-require') { |name| require(name) }

      define('+') { with_args(2){ |a1,a2| a1 + a2 } }
      define('-') { with_args(2){ |a1,a2| a1 - a2 } }
      define('*') { with_args(2){ |a1,a2| a1 * a2 } }
      define('/') { with_args(2){ |a1,a2| a1 / a2 } }
      define('=') { with_args(2){ |a1,a2| a1 == a2 } }
      define('<=') { with_args(2){ |a1,a2| a1 <= a2 } }
      define('>=') { with_args(2){ |a1,a2| a1 >= a2 } }
      define('and') { with_args(2){ |a1,a2| a1 && a2 } }
      define('or') { with_args(2){ |a1,a2| a1 || a2 } }
      define('not'){ with_args(1){ |a1| not a1 } }

      define('print') { with_args(1) { |x| puts x } }
      define('print-'){ with_args(1) { |x| print x } }

      #define('callm') { |methodname, object, *args| object.send(methodname.to_sym, *args) }

      define('first') { with_args(1) { |list| list.first } }
      define('rest') { with_args(1) { |list| list[1..-1] } }
      define('empty?') { with_args(1) { |list| list.empty? } }
      define('nil?') { with_args(1) { |obj| obj.nil? } }
      define('map') { with_args(2) { |func, list| list.map{ |e| func.call(self, [e]) } } }

      define('dup'){ with_args(1) { |a| DS << a; DS << a } }

      define('array<<'){ |list| Array.new(list) }
    end
  end
end
