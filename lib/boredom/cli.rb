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
          #{'Usage'.magenta.bold}:
            #{'bdm'.cyan} #{'<command>'.yellow}

          #{'Commands'.magenta.bold}:
            #{'encode'.cyan}  convert to encoding
            #{'decode'.cyan}  convert to json
            #{'help'.cyan}    show this message

          #{'Examples'.magenta.bold}:
            #{'bdm'.cyan} #{'encode'.yellow} #{'hello.json'.yellow} #{'hello.bdm'.yellow}  encode hello.json into hello.bdm
            #{'bdm'.cyan} #{'decode'.yellow} #{'hello.bdm'.yellow} #{'hello.json'.yellow}  decode hello.bdm into hello.json
        HELP

        exit 0
      end
    end
  end
end
