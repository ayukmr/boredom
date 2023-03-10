module Boredom
  # encoding decoder
  module Decoder
    class << self
      # decode into hash
      def decode(value)
        reader = Reader.new(value)
        decode_value(reader)
      end

      # decode single value
      def decode_value(reader)
        type = reader.read(1).ord

        case type
        # decode hash
        when 0
          decode_hash(reader)

        # decode array
        when 1
          decode_array(reader)

        # decode boolean
        when 2, 3
          decode_boolean(type)

        # decode integer
        when 4..7
          decode_integer(reader, type)

        # decode float
        when 8..11
          decode_float(reader, type)

        # decode string
        when 12
          decode_string(reader)
        end
      end

      # decode hash
      def decode_hash(reader)
        sets = reader.read(1).ord
        sets.times.to_h do
          # get key for set
          key_length = reader.read(1).ord
          key = reader.read(key_length)

          [key, decode_value(reader)]
        end
      end

      # decode array
      def decode_array(reader)
        ary_length = reader.read(1).ord
        ary_length.times.map { decode_value(reader) }
      end

      # decode boolean
      def decode_boolean(type)
        type == 2
      end

      # decode integer
      def decode_integer(reader, type)
        number =
          if [5, 7].include?(type)
            from_chars(reader.read(2))
          else
            reader.read(1).ord
          end

        [6, 7].include?(type) ? -number : number
      end

      # decode float
      def decode_float(reader, type)
        number =
          if [9, 11].include?(type)
            from_chars(reader.read(2))
          else
            reader.read(1).ord
          end

        # add decimal
        decimal = reader.read(1).ord
        number += decimal.zero? ? 0.to_f : 1 / decimal.to_f

        [10, 11].include?(type) ? -number : number
      end

      # decode string
      def decode_string(reader)
        value_length = reader.read(1).ord
        reader.read(value_length)
      end

      # convert from characters
      def from_chars(value)
        codepoints = value.codepoints
        (codepoints[0] * 1_048_575) + codepoints[1]
      end
    end
  end
end
