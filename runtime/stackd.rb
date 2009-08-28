require 'rubygems'
require 'treetop'
require 'pp'

["datastack",
 "primitives/syntax",
 "primitives/functions",
 "nodes",
 "scope",
 "function"].each do |path|
  require File.dirname(__FILE__) + '/' + path
end

module Stackd
  def self.run(path, dynparser = false, debug_on = false, argv = [])

    if dynparser
      Treetop.load File.dirname(__FILE__) + '/stackdgrammar.treetop'
    else
      require File.dirname(__FILE__) + "/stackdgrammar"
    end

    scope = TopLevel.new
    scope["ARGV"] = argv

    # load stackd core library
    Dir["core/*.stackd"].each do |file|
      parse_eval_file(file, scope)
    end

    # finally, parse & eval main file
    parse_eval_file(path, scope, debug_on)
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
end
