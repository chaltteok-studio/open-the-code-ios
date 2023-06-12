#
#  query_reader.rb
#  
#
#  Created by JSilver on 2023/06/01.
#

require 'readline'

# Query
class Query
    # Property
    attr_accessor :key
    attr_accessor :message
    attr_accessor :default
    attr_accessor :required

    # Initializer
    def initialize(key, message, default: nil, required: false)
        @key = key
        @message = message
        @default = default
        @required = required
    end

    # Public

    # Private
    private
end

# QueryReader
class QueryReader
    # Property

    # Initailzer
    def initialize(queries)
        @queries = queries
    end

    # Public
    def read()
        results = {}
        
        @queries&.each do |query|
            # Read value from query.
            value = Readline.readline(query.message, true)
            
            if query.required && value.empty?
                abort("Error: required argument is empty.")
            end

            results[query.key] = value.empty? ? query.default : value
        end

        results
    end

    # Private
    private
end
