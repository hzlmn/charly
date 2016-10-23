# Interpreter
require "./stack/stack.cr"
require "./interpreter.cr"
require "./session.cr"

# Parsing
require "../syntax/parser.cr"

class InterpreterFascade
  include Charly::Parser

  property top : Stack
  property session : Session

  def initialize(@session)
    @top = Stack.new nil
  end

  def execute_file(file, stack = @top)

    # Parsing
    parser = Parser.new file, @session
    parser.parse
    program = parser.tree

    # Setup the stack
    stack.file = file

    # Execute the file in the interpreter
    unless @session.flags.includes? "noexec"
      # Interpreter.new([program], stack, @session).program_result
    else
      CharlyTypes::TNull.new
    end
  end
end
