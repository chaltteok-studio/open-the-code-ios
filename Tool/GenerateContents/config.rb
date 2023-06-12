#
#  config.rb
#  
#
#  Created by JSilver on 2023/06/01.
#

class Config
    # Constants

    # Property
    attr_reader :config

    # Initializer
    def initialize(path, scheme: {})
        # Load yaml config file.
        yaml = File.exist?(path) ? YAML.load_file(path) : nil
        @config = _update(scheme, convert(yaml))
    end

    # Public
    def [](key)
        @config[key]
    end

    def []=(key, value)
        @config[key] = value
    end

    def update(object)
        _update(@config, object)
    end

    # Private
    private
    def convert(object)
        if object.is_a? Array
            # Convert sub items of array.
            object.map { |item| convert(item) }
        elsif object.is_a? Hash
            # Convert sub items of hash.
            object.each_with_object({}) do |(key, value), result|
                result[key.to_s.gsub(/_\w/) { |m| m[1].upcase }.to_sym] = convert(value)
            end
        else
            # Return object or empty.
            object || { }
        end
    end

    def _update(lhs, rhs)
        if (lhs.is_a? Hash) && (rhs.is_a? Hash)
            # Update sub items of hash.
            lhs.each do |key,  value|
                lhs[key] = _update(lhs[key], rhs[key])
            end
        else
            # Return rhs or return lhs if rhs is `nil`.
            rhs || lhs
        end
    end
end
