module Boredom
  # encoding encoder
  module Encoder
    class << self
      # encode value
      def encode(value)
        type_char = type_char(value)
        encoded_value = encode_value(value)

        "#{type_char}#{encoded_value}"
      end

      # get character for type
      def type_char(value)
        case value
        # numbers
        when Integer, Float
          type_char_number(value)

        # map class to character
        else
          {
            'Hash'       => 0,
            'Array'      => 1,
            'TrueClass'  => 2,
            'FalseClass' => 3,
            'String'     => 12
          }[value.class.name].uchr
        end
      end

      # get type character for number
      def type_char_number(value)
        offset = value.is_a?(Float) ? 4 : 0

        # negative numbers
        if value.negative?
          value = value.abs
          offset += 2
        end

        # short and long numbers
        if value <= 1_048_575
          (4 + offset).uchr
        else
          (5 + offset).uchr
        end
      end

      # convert value to string
      def encode_value(value)
        case value
        # hash as string
        when Hash
          encode_hash(value)

        # array as string
        when Array
          encode_array(value)

        # integer as string
        when Integer
          encode_integer(value)

        # float as string
        when Float
          encode_float(value)

        # string value
        when String
          encode_string(value)
        end
      end

      # encode hash
      def encode_hash(value)
        "#{value.length.uchr}#{value.map do |hash_key, hash_val|
          "#{hash_key.length.uchr}#{hash_key}#{encode(hash_val)}"
        end.join}"
      end

      # encode array
      def encode_array(value)
        "#{value.length.uchr}#{value.map { |ary_val| encode(ary_val) }.join}"
      end

      # encode integer
      def encode_integer(value)
        if value > 1_048_575
          # long integer
          to_chars(value)
        else
          # short integer
          value.uchr
        end
      end

      # encode float
      def encode_float(value)
        value = value.to_d

        decimal = (1 / value.frac).to_i
        decimal = decimal == BigDecimal::INFINITY ? "\0" : decimal.uchr

        value = value.floor

        if value > 1_048_575
          # long integer
          to_chars(value) + decimal
        else
          # short integer
          value.uchr + decimal
        end
      end

      # encode string
      def encode_string(value)
        "#{value.length.uchr}#{value}"
      end

      # convert to characters
      def to_chars(value)
        "#{(value / 1_048_575).uchr}#{(value % 1_048_575).uchr}"
      end
    end
  end
end
