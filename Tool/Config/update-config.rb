#
#  update-config.rb
#  
#
#  Created by JSilver on 2023/04/25.
#

# Config
class Config
    # Constant
    MARKETING_VERSION_KEY = "MARKETING_VERSION"
    CURRENT_PROJECT_VERSION_KEY = "CURRENT_PROJECT_VERSION"
    
    # Property
    attr_accessor :body

    # Initializer
    def initialize(path)
        @body = File.read(path)
    end

    # Public
    def update(value, key)
        @body.gsub!(/#{key} = .*/, "#{key} = #{value}")
    end

    # Private
    private
end

# Functions
def updateConfig(configPath, version, build)
    # Instantiate config.
    config = Config.new(configPath)

    # Update configs.
    config.update(version, Config::MARKETING_VERSION_KEY)
    config.update(build, Config::CURRENT_PROJECT_VERSION_KEY)

    # Overwrite config file.
    File.write(configPath, config.body) 
end
  
# Main
def main(argv)
    # Get arguments
    configPath = ARGV[0]
    version = ARGV[1]
    build = ARGV[2]

    if version.nil? || build.nil?
        abort("Usage: update-config <xcconfig path> <version> <build>")
    end

    updateConfig(configPath, version, build)
end

main(ARGV)
