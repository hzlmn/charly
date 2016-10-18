require "./charly/file.cr"
require "./charly/interpreter/fascade.cr"
require "./charly/interpreter/session.cr"
require "./charly/interpreter/types.cr"
require "option_parser"

module Charly
  include CharlyTypes

  arguments = [] of String
  flags = [] of String
  filename = ""

  available_flags = <<-FLAGS

  Flags:
      ast                              Display AST's of parsed programs
      tokens                           Display tokens of parsed programs
      noexec                           Disable execution
      noprelude                        Don't load the prelude file
      stackdump                        Dump the top-level stack at the end of execution
  FLAGS

  OptionParser.parse! do |opts|
    opts.banner = "Usage: charly [options] filename [arguments]"
    opts.on("-f FLAG", "--flag FLAG", "Set a flag") { |flag|
      flags << flag
    }
    opts.on("-h", "--help", "Show this help") {
      puts opts
      puts available_flags
      exit
    }
    opts.on("-v", "--version", "Show the version number") {
      puts "0.0.0"
      exit
    }
    opts.invalid_option {} # ignore
    opts.unknown_args do |before_dash|
      before_dash = before_dash.to_a
      if before_dash.size == 0
        before_dash.unshift "repl"
      end

      filename = before_dash.shift
      arguments = before_dash

      # If the filename is repl, expand the path to the repl.charly file
      if filename == "repl"
        filename = ENV["CHARLYDIR"] + "/repl.charly"
      end
    end
  end

  # The current session
  session = Session.new(arguments, flags)

  # Initialise the different layers
  top_stack = Stack.new(nil)
  prelude_stack = Stack.new(top_stack)
  primitives_stack = Stack.new(prelude_stack) # The stack that hosts the primitive classes
  userfile_stack = Stack.new(prelude_stack)

  # Insert ARGV, IFLAGS and ENV
  top_stack.write("ARGV", TArray.new_from_strings(arguments), declaration: true, constant: true)
  top_stack.write("IFLAGS", TArray.new_from_strings(flags), declaration: true, constant: true)
  top_stack.write("ENV", TObject.new_from_hash(ENV, prelude_stack), declaration: true, constant: true)

  # Execute the needed files
  interpreter = InterpreterFascade.new(session, primitives_stack, prelude_stack)
  interpreter.execute_file(RealFile.new(ENV["CHARLYDIR"] + "/prelude.charly"), prelude_stack)
  interpreter.execute_file(RealFile.new(ENV["CHARLYDIR"] + "/primitives/include.charly"), primitives_stack)
  interpreter.execute_file(RealFile.new(filename), userfile_stack)

  # If the stackdump flag was set
  # display the userstack at the end of execution
  if flags.includes? "stackdump"
    puts userfile_stack
  end
end
