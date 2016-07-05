require_relative "lexer"
require_relative "token_type"

class Token
  def operator?
    [:add, :sub, :mult, :div].include? @token_type.id
  end
end

class Calculator
  def initialize
    token_types = []
    token_types << TokenType.new(:add, /\+/, :precedence => 10)
    token_types << TokenType.new(:sub, /-/, :precedence => 10)
    token_types << TokenType.new(:mult, /\*/, :precedence => 20)
    token_types << TokenType.new(:div, /\//, :precedence => 20)
    token_types << TokenType.new(:pinteger, /\d+/)
    token_types << TokenType.new(:whitespace, /\s+/, :ignore => true)
    token_types << TokenType.new(:lparen, /\(/, :precedence => 1)
    token_types << TokenType.new(:rparen, /\)/, :precedence => 1)

    @lexer = Lexer.new(token_types)   
  end

  def run(expression)
    evaluate(to_postfix(@lexer.tokenize(expression)))
  end 

  private 
    # Converts the expression to postfix notation using the Shunting-yard algorithm
    def to_postfix(tokens)
      opstack = []
      output = []
      lparen = 0
      
      tokens.each do |token|        
        # If the token is an operand, append it to the end of the output list
        if token.token_type.id == :pinteger
          output << token
        end

        # If the token is a left parenthesis, push it on the opstack
        if token.token_type.id == :lparen
          opstack << token
        end
      
        # If the token is a right parenthesis, pop the opstack until the 
        # corresponding left parenthesis is removed. Append each operator to the 
        # end of the output list.
        if token.token_type.id == :rparen
          loop do
              raise "Malformed expression: parenthesis mismatch" if opstack.empty?
              top = opstack.pop           
              break if top.token_type.id == :lparen
              output << top
          end
        end

        # If the token is an operator, *, /, +, or -, push it on the opstack. 
        # However, first remove any operators already on the opstack that have
        # higher or equal precedence and append them to the output list.
        if token.operator?        
          until opstack.empty? or 
            opstack.last.token_type.options[:precedence] < token.token_type.options[:precedence]
            output << opstack.pop
          end
          
          opstack << token
        end
      end

      # When the input expression has been completely processed, check the 
      # opstack. Any operators still on the stack can be removed and appended 
      # to the end of the output list.    
      until opstack.empty?      
        output << opstack.pop
      end

      output
    end

    def evaluate (postfix_expression)
      stack = []

      postfix_expression.each do |token|
        if token.token_type.id == :pinteger
          stack.push(token.value)
        else
          op2 = stack.pop
          op1 = stack.pop
          
          case token.token_type.id
          when :add
            stack.push(op1.to_i + op2.to_i)
          when :sub
            stack.push(op1.to_i - op2.to_i)
          when :mult
            stack.push(op1.to_i * op2.to_i)
          when :div
            raise "Can't divide by zero!" if op2.to_i == 0
            stack.push(op1.to_i / op2.to_i)
          end
        end
      end

      stack.pop unless stack.empty?
    end
end
