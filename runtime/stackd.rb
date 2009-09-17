require 'rubygems'
require 'treetop'
require 'pp'

["stacks",
 "primitives/syntax",
 "primitives/words",
 "nodes",
 "scope",
 "word",
 "tuple"].each do |path|
  file = File.expand_path(File.dirname(__FILE__)) + '/' + path
  require file
end

module Stackd
  # return a list (array) of all defined symbols in the system
  def self.defined_symbols(scope)
    arr = []
    arr += scope.symbols.keys
    arr += scope.tuples.keys
    arr += scope.generics.keys

    # recursively for all children as well
    if scope.respond_to?(:children)
      arr += scope.children.collect do |child_scope|
        defined_symbols(child_scope)
      end.flatten
    end

    arr
  end

  def self.run(path, dynparser = false, debug_on = false, argv = [])
    if dynparser
      Treetop.load File.dirname(__FILE__) + '/stackdgrammar.treetop'
    else
      require File.dirname(__FILE__) + "/stackdgrammar"
    end

    scope = TopLevel.new
    scope["ARGV"] = argv

    stackd_root_path = File.expand_path(File.dirname(__FILE__)) + "/../"
    load_corelib(scope, stackd_root_path)

    # finally, parse & eval main file
    parse_eval_file(path, scope, debug_on)
  end

  # load stackd core library
  def self.load_corelib(scope, root_path = "")
    scope["**root_path**"] = root_path
    pattern = root_path + "core/*.stackd"
    Dir[pattern].each do |file|
      parse_eval_file(file, scope)
    end
  end

  def self.parse(string)
    @parser ||= StackdParser.new
    @parser.parse(string)
  end

  def self.parse_eval_file(filename, scope, debug_on = false)
    ast = parse File.read(filename)
    puts ast.inspect if debug_on
    if ast
      ast.eval(scope)
    else
      parse_error(filename)
    end
  end

  def self.parse_error(filename)
    # if parsing failed -> output error message with reason
    puts "ParseError in #{filename} (line #{@parser.failure_line} / #{@parser.failure_column}):"
    puts "#{@parser.failure_reason}"
    exit
  end

  def self.version
    "0.1"
  end
end
