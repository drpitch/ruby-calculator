class TokenType
  attr_reader :id, :pattern, :options

  def initialize(id, pattern, options = {})
    default_options = {
      :ignore => false
    }

    @id = id
    @pattern = pattern
    @options = default_options.merge(options)
  end
end
