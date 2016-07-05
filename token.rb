class Token
  attr_reader :token_type, :value

  def initialize(token_type, value)
    @token_type = token_type
    @value = value
  end

  def to_s
    "#{@token_type.id} (#{@value})"
  end
end
