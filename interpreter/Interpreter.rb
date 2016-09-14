require_relative "../syntax/AST.rb"
require_relative "stack.rb"
require_relative "types.rb"
require_relative "../misc/Helper.rb"

# Runs a given program
class Interpreter
  attr_reader :last_result

  # Initialize the interpreter and insert all required programs
  def initialize(programs)

    # The global stack all programs have access to
    main = Stack.new NIL

    # Execute all programs
    @last_result = Executor.exec_programs(programs, main)
  end
end

# Contains class methods to execute different nodes
class Executor

  # Execute a bunch of programs, each having access to a shared top stack
  def self.exec_programs(programs, stack)
    last_result = Types::NullType.new
    programs.each do |program|
      last_result = self.exec_program(program, stack)
    end
    last_result
  end

  # Program node
  def self.exec_program(program, stack)

    # Check if the program should be executed
    unless program.should_execute
      return Types::NullType.new
    end

    # Debugging
    dlog "Executing program: #{yellow(program.file.filename)}"

    # Check if the program contains a block
    if program.children.length == 1

      # Create a new block
      return self.exec_block(program.children[0], stack)
    end

    # If the program didn't contain anything,
    # return the NullType
    return Types::NullType.new
  end

  # Execute a single block,
  # also passing it a stack
  def self.exec_block(block, stack)
    last_result = Types::NullType.new
    block.children.each do |expression|
      last_result = self.exec_expression(expression, stack)
    end
    last_result
  end

  # Execute a single expression node
  def self.exec_expression(node, stack)
    if node.is VariableInitialisation
      return self.exec_variable_initialisation(node, stack)
    end

    if node.is VariableDeclaration
      return self.exec_variable_declaration(node, stack)
    end

    if node.is VariableAssignment
      return self.exec_variable_assignment(node, stack)
    end

    if node.is BinaryExpression
      return self.exec_binary_expression(node, stack)
    end

    if node.is ComparisonExpression
      return self.exec_comparison_expression(node, stack)
    end

    if node.is FunctionDefinitionExpression
      return self.exec_function_definition(node, stack)
    end

    if node.is CallExpression
      return self.exec_call_expression(node, stack)
    end

    if node.is WhileStatement
      return self.exec_while_statement(node, stack)
    end

    if node.is IfStatement
      return self.exec_if_statement(node, stack)
    end

    if node.is NumericLiteral, StringLiteral, BooleanLiteral
      return self.exec_literal(node, stack)
    end

    if node.is IdentifierLiteral
      return self.exec_identifier_literal(node, stack)
    end

    if node.is FunctionLiteral
      return self.connect_function_to_stack(node, stack)
    end

    # Nested expressions inside a statement
    if node.is(Statement) && node.children.length == 1
      if node.children[0].is Expression, NumericLiteral, StringLiteral, IdentifierLiteral
        return self.exec_expression(node.children[0], stack)
      end
    end

    return Types::NullType.new
  end

  # Execute a variable initialisation
  # Saves a variable into the current stack
  # the return value is the value of the variable
  def self.exec_variable_initialisation(node, stack)
    value = self.exec_expression(node.expression, stack)
    stack[node.identifier.value, true] = value
    value
  end

  # Execute a variable initialisation
  # Reserves a variable in the current stack
  # the return value is NULL
  def self.exec_variable_declaration(node, stack)
    value = Types::NullType.new
    stack[node.identifier.value, true] = value
    value
  end

  # Assign a value to a variable inside the current stack
  # the return value is the value of the identifier
  # after the assignment
  def self.exec_variable_assignment(node, stack)
    value = self.exec_expression(node.expression, stack)
    stack[node.identifier.value, false] = value

    # Return value is the value of the variable
    # after the assignment
    #
    # not the value passed in
    return stack[node.identifier.value]
  end

  # Perform a binary expression
  def self.exec_binary_expression(node, stack)
    left = self.exec_expression(node.left, stack)
    right = self.exec_expression(node.right, stack)

    # TODO: Type-check and possily do casting?
    result = Types::NullType.new
    result = case node.operator
    when PlusOperator
      left.value + right.value
    when MinusOperator
      left - right
    when MultOperator
      left * right
    when DivdOperator
      left / right
    when ModOperator
      left % right
    when PowOperator
      left ** right
    end

    return Types.new(result)
  end

  # Perform a comparison operation
  def self.exec_comparison_expression(node, stack)
    left = self.exec_expression(node.left, stack).value
    right = self.exec_expression(node.right, stack).value

    case node.operator
    when GreaterOperator
      return Types::BooleanType.new(left > right)
    when SmallerOperator
      return Types::BooleanType.new(left < right)
    when GreaterEqualOperator
      return Types::BooleanType.new(left >= right)
    when SmallerEqualOperator
      return Types::BooleanType.new(left <= right)
    when EqualOperator
      return Types::BooleanType.new(left == right)
    when NotEqualOperator
      return Types::BooleanType.new(left != right)
    end
  end

  # Define a function in the current stack
  def self.exec_function_definition(node, stack)
    function = node.function
    function.block.parent_stack = stack
    stack[function.identifier.value, true] = function

    # The return value of a function definition
    # is the function itself
    stack[function.identifier.value]
  end

  # Execute a call expression
  # returns the result of the expression
  def self.exec_call_expression(node, stack)

    # Evaluate all arguments first
    arguments = []
    node.argumentlist.each do |argument|
      arguments << self.exec_expression(argument, stack)
    end

    # Get the function that's being executed
    function = Types::NullType.new

    # check if the function is a function literal
    if node.identifier.is(FunctionLiteral)
      function = node.identifier
    elsif node.identifier.is(IdentifierLiteral)

      # Check for an internal function call
      if node.identifier.value == "call_internal"
        return self.exec_internal_function(arguments[0], arguments[1..-1], stack)
      end

      # Check the stack for a function definition
      stack_value = stack[node.identifier.value]
      if stack_value && stack_value.is(FunctionLiteral)
        function = stack_value
      else
        raise "#{node.identifier.value} is not a function!"
      end
    end

    # Get the identities of the arguments that are required
    argument_ids = function.argumentlist.children.map do |argument|
      argument.value
    end

    # Check if the correct amount of arguments was passed
    if arguments.length < argument_ids.length
      raise "#{function.identifier.value} expected #{argument_ids.length} argument(s), got #{arguments.length} instead!"
    end

    # Create new stack for the function arguments to be saved in
    # and to be passed to self.exec_block
    function_stack = Stack.new(function.block.parent_stack)
    arguments.each_with_index do |arg, index|
      function_stack[argument_ids[index], true] = arg
    end

    # Execute the block
    return self.exec_block(function.block, function_stack)
  end

  # Execute an internal function
  # name is a Types::StringType object
  # arguments is just an array of the arguments passed at run-time
  def self.exec_internal_function(name, arguments, stack)
    case name.value
    when "print"
      arguments.each do |arg|
        if arg.is_a? Types::NullType
          puts "NIL"
        else
          puts arg.value
        end
      end
      return Types::NullType.new
    when "Boolean"
      return Types::BooleanType.new(eval_bool(arguments[0].value))
    when "Number"
      return Types::NumericType.new(arguments[0].value.to_f)
    when "String"
      return Types::StringType.new(arguments[0].value.to_s)
    when "gets"
      return Types::StringType.new($stdin.gets)
    when "chomp"
      return Types::StringType.new(arguments[0].value)
    when "sleep"
      sleep(arguments[0].value)
      return Types::NullType.new
    when "variable"
      return stack[arguments[0].value]
    when "print_color"
      puts colorize(arguments[0].value, arguments[1].value)
      return Types::NullType.new
    end
  end

  # Execute a while statement
  # the return value of the while statement is the last expression
  # inside the last block executed
  def self.exec_while_statement(node, stack)
    last_result = Types::NullType.new
    while self.eval_bool(self.exec_expression(node.test, stack), stack) do
      last_result = self.exec_block(node.consequent, Stack.new(stack))
    end
    last_result
  end

  # Execute an if statement
  # the return value is the last expression in the last block executed
  def self.exec_if_statement(node, stack)

    # Evaluate the test expression
    test_result = self.eval_bool(self.exec_expression(node.test, stack), stack)

    # Run the respective handler
    if test_result
      return self.exec_block(node.consequent, Stack.new(stack))
    else
      if node.alternate
        if node.alternate.is(IfStatement)
          return self.exec_if_statement(node.alternate, stack)
        elsif node.alternate.is(Block)
          return self.exec_block(node.alternate, Stack.new(stack))
        end
      end
    end
  end

  # Cast a literal node of the ast
  # into the runtime representation of values
  def self.exec_literal(node, stack)
    case node
    when NumericLiteral
      return Types::NumericType.new(node.value)
    when StringLiteral
      return Types::StringType.new(node.value)
    when BooleanLiteral
      return Types::BooleanType.new(node.value)
    end
  end

  # Return the value of an identifier
  def self.exec_identifier_literal(node, stack)
    return stack[node.value]
  end

  # Inline function literal
  # this just connects the function to the right parent stack
  def self.connect_function_to_stack(node, stack)
    node.block.parent_stack = stack
    return node
  end

  # Returns true or false for a given value
  def self.eval_bool(value, stack)
    case value
    when Types::NumericType
      return value.value != 0
    when Types::BooleanType::True
      return true
    when Types::BooleanType::False
      return false
    when TrueClass
      true
    when FalseClass
      false
    else
      return true
    end
  end
end
