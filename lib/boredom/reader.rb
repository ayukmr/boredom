module Boredom
  # string reader
  class Reader
    # create reader
    def initialize(string)
      @index  = 0
      @string = string
    end

    # read characters
    def read(amount)
      error 'invalid boredom data' if @index + amount > @string.length

      segment = @string[@index..@index + amount - 1]
      @index += amount

      segment
    end
  end
end
