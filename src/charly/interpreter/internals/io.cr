require "readline"
require "../**"

module Charly::Internals

  charly_api "stdout_print", variadic: true do
    arguments.each do |arg|
      STDOUT.puts arg.to_s
      STDOUT.flush
    end
    return TNull.new
  end

  charly_api "stdout_write", variadic: true do
    arguments.each do |arg|
      STDOUT.print arg.to_s
      STDOUT.flush
    end
    return TNull.new
  end

  charly_api "stderr_print", variadic: true do
    arguments.each do |arg|
      STDERR.puts arg.to_s
      STDERR.flush
    end
    return TNull.new
  end

  charly_api "stderr_write", variadic: true do
    arguments.each do |arg|
      STDERR.print arg.to_s
      STDERR.flush
    end
    return TNull.new
  end

  # Reads a single char from STDIN (without the need of pressing return)
  charly_api "stdin_getc" do
    char = STDIN.raw &.read_char
    return TString.new(char.to_s)
  end

  # Read a string (return terminated) from STDIN
  # Prepends *prepend* to the input and adds to the history if *history* is passed
  charly_api "stdin_gets", prepend : TString, history : TBoolean do
    return TString.new(Readline.readline(prepend.value, history.value) || "")
  end

  # Exit the program
  # *code* is used as the exit code
  charly_api "exit", code : TNumeric do
    exit(code.value.to_i)
    return TNull.new
  end

  # Returns the current scope rendered as a string
  charly_api "stackdump" do
    return TString.new(scope.to_s)
  end
end
