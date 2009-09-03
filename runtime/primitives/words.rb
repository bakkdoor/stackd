module Primitives
  module Words
    def with_args(n, &block)
      args = DS.take(n).reverse
      DS << block.call(*args)
    end

    def init_primitive_functions
      define_word('ruby-require'){
        with_args(1){ |name| require(name) }
      }

      define_word('+'){ with_args(2){ |a1,a2| a1 + a2 } }
      define_word('-'){ with_args(2){ |a1,a2| a1 - a2 } }
      define_word('*'){ with_args(2){ |a1,a2| a1 * a2 } }
      define_word('/'){ with_args(2){ |a1,a2| a1 / a2 } }
      define_word('mod'){ with_args(2) { |n,m| n.modulo(m) } }
      define_word('='){ with_args(2){ |a1,a2| a1 == a2 } }
      define_word('<='){ with_args(2){ |a1,a2| a1 <= a2 } }
      define_word('>='){ with_args(2){ |a1,a2| a1 >= a2 } }
      define_word('and'){ with_args(2){ |a1,a2| a1 && a2 } }
      define_word('or'){ with_args(2){ |a1,a2| a1 || a2 } }
      define_word('not'){ with_args(1){ |a1| not a1 } }

      define_word('print'){ with_args(1) { |x| puts x } }
      define_word('print-'){ with_args(1) { |x| print x } }

      define_word('callm') {
        with_args(3){ |object,methodname,args| object.send(methodname.to_sym, *args) }
      }

      define_word('first'){ with_args(1) { |list| list.first } }
      define_word('rest'){ with_args(1) { |list| list[1..-1] } }
      define_word('nth'){ with_args(2) { |n,list| list[n] } }
      define_word('empty?'){ with_args(1) { |list| list.empty? } }
      define_word('nil?'){ with_args(1) { |obj| obj.nil? } }

      define_word('map'){
        with_args(2){ |list, quot|
          list.collect do |x|
            DS << x
            quot.call(self)
            DS.pop
          end
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
      define_word('dip'){
        with_args(2){ |x,quot| RS << x; quot.call(self); RS.pop }
      }

      define_word('2dip'){
        with_args(3){ |x,y,quot|
          RS << y
          RS << x
          quot.call(self)
          DS << RS.pop
          RS.pop
        }
      }

      define_word('3dip'){
        with_args(4){ |x,y,z,quot|
          RS << z; RS << y; RS << x
          quot.call(self)
          DS << RS.pop; DS << RS.pop
          RS.pop
        }
      }

      define_word('inspect'){ with_args(1){ |a| a.inspect } }
      define_word('.'){ with_args(1){ |a| puts a.inspect } }
      define_word('pp'){ with_args(1){ |a| pp a } }

      define_word('clear') { DS.clear; nil }
      define_word('call') { with_args(1) { |quot| quot.call(self); nil } }
      define_word('if') {
        with_args(3) { |cond,then_quot,else_quot|
          (cond ? then_quot : else_quot).call(self)
          nil
        }
      }

      define_word('curry'){
        with_args(2){ |obj,quot|
          Word.new(self){
            DS << obj
            quot.call(self)
          }
        }
      }

      define_word('compose'){
        with_args(2){ |quot1,quot2|
          Word.new(self){
            quot1.call(self)
            quot2.call(self)
          }
        }
      }

      define_word('times'){
        with_args(2){ |quot,n|
          n.times{ quot.call(self) }
          nil
        }
      }

      define_word('in-thread'){
        with_args(1){ |quot|
          Thread.new{
            quot.call(self)
          }
          nil
        }
      }

      define_word('sleep'){
        with_args(1){ |n|
          sleep(n)
          nil
        }
      }

      define_word('seq?'){ with_args(1){ |seq| seq.is_a?(Array) } }

      define_word('<a,b>'){ with_args(2){ |n,m| (n..m) } }
      define_word('array<<'){ |list| Array.new(list) }
      define_word('<<'){ with_args(2){ |seq, elem| seq << elem } }

      define_word('new'){
        with_args(1){ |tuple|
          if tuple.is_a?(Tuple)
            DS << tuple.create_instance
          else
            raise "Unknown Tuple: #{tuple.inspect}"
          end
          nil
        }
      }
    end
  end
end
