require_relative 'token'
require 'strscan'

class Lexer
  def initialize(token_types)
    @token_types = token_types
  end

  def tokenize(input)
    scanner = StringScanner.new(input)
    tokens = []

    until scanner.eos?
      pos = scanner.pos
      
      @token_types.each do |token_type|
        match = scanner.scan(token_type.pattern)
        tokens.push << Token.new(token_type, match) unless 
            match.nil? or token_type.options[:ignore]
      end

      if pos == scanner.pos
        raise "Invalid token found near '#{scanner.rest()}'"
        scanner.terminate
      end
    end

    tokens
  end
end

