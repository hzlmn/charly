require "./types.cr"

module Charly::Internals
  extend self

  # :nodoc:
  class Methods
    METHODS = [] of String
  end

  # Declare a new internal method called *name* with *types*
  #
  # ```
  # charly_api "sleep", time : TNumeric do
  #   sleep time.value
  #   return TString.new("Slept for #{time} seconds")
  # end
  # ```
  macro charly_api(name, *types, variadic = false)
    class Methods
      def self.__charly_api_{{name.id}}(call, visitor, scope, context, argc : Int32, arguments : Array(BaseType))
        name = {{name}}
        types = [{{
                  *types.map do |field|
                    field.type
                  end
                }}] of BaseType.class

        # Argument count check
        if argc < {{types.size}}
          raise RunTimeError.new(call.identifier, "#{{{name}}} expected #{types.size} arguments, got #{argc}")
        end

        # Argument type check
        {% for type, index in types %}

          arg{{index}} = arguments[{{index}}]

          if !arg{{index}}.is_a?({{type.type}})
            raise RunTimeError.new(call.argumentlist[{{index}}], "#{{{name}}} expected argument #{{{index + 1}}} to be of type #{{{type.type}}}, got #{arguments[{{index}}].class}")
          end

          {{type.var}} = arg{{index}}
        {% end %}

        {{yield}}
      end

      METHODS << {{name}}
    end
  end
end

require "./internals/**"
