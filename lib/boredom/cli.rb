module Boredom
  # boredom cli
  class CLI
    class << self
      # run cli with argv
      def run(argv)
        command = argv[0]
        help unless command

        case command
        # encode and decode files
        when 'encode', 'decode'
          input, output = argv[1..]

          # ensure input and output files are given
          error 'input file or output file not given' unless input && output

          # ensure input file exists
          error "file `#{input.tilde}` does not exist" unless File.exist?(input)

          contents = File.binread(input)
          result =
            if command == 'encode'
              # convert json to encoding
              data = JSON.parse(contents)
              Boredom::Encoder.encode(data)
            else
              # convert encoding to json
              Boredom::Decoder.decode(contents).to_json
            end

          File.binwrite(output, result)

        # show help
        when 'help'
          help

        # invalid command
        else
          error "command `#{command}` does not exist"
        end
      end

      # show help and exit
      def help
        puts <<~HELP
          #{'usage'.magenta.bold}:
            #{'bdm'.blue} #{'<command>'.yellow}

          #{'commands'.magenta.bold}:
            #{'encode'.blue} #{'<json>'.yellow} #{'<bdm>'.yellow}   convert to encoding
            #{'decode'.blue} #{'<bdm>'.yellow}  #{'<json>'.yellow}  convert to json
            #{'help'.blue}                  show this message
        HELP

        exit 0
      end
    end
  end
end
