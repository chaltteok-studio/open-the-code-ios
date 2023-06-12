#
#  generate_package.rb
#  
#
#  Created by JSilver on 2023/05/31.
#

require 'yaml'

require_relative 'config.rb'
require_relative 'query_reader.rb'
require_relative 'tbuilder.rb'

# Constants
CONFIG_PATH = "gpconfig.yml"
PROMPT_PATH = "#{__dir__}/prompt.yml"

DEMO_TEMPLATE_PATH = "#{__dir__}/Template/Demo"
PACKAGE_TEMPLATE_PATH = "#{__dir__}/Template/Package"

# Generator
class Generator
    # Property

    # Initializer
    def initialize(packageName, packagePath, author)
        @packageName = packageName
        @packagePath = packagePath
        @author = author
    end

    # Public
    def generate(type, options, config)
        case type
        when :demo
            outputPath = "#{@packagePath}/#{@packageName}.swiftpm"
            generateDemo(outputPath, options, config)

        when :package
            outputPath = "#{@packagePath}/#{@packageName}"
            generatePackage(outputPath, options, config)
        end
    end

    # Private
    private
    def generateDemo(outputPath, options, config)
        if options[:dependencyPath]
            options[:dependencyPath] = Pathname.new(options[:dependencyPath])
                .relative_path_from(outputPath)
        end

        TBuilder.new(DEMO_TEMPLATE_PATH)
            .build(
                to: outputPath,
                data: {
                    :packageName => @packageName,
                    :author => @author,
                    :options => options,
                    :config => config
                }
            )
    end

    def generatePackage(outputPath, options, config)
        TBuilder.new(PACKAGE_TEMPLATE_PATH)
            .build(
                to: outputPath,
                data: {
                    :packageName => @packageName,
                    :author => @author,
                    :options => options,
                    :config => config
                }
            )
    end
end

# Functions
def makeQueries(type, prompts, required:, options:)
    {
        :required => required.map { |key| makeQuery(key, prompts) },
        :options => options[type].map { |key| makeQuery(key, prompts) }
    }
end

def makeQuery(key, prompts)
    Query.new(
        key, 
        prompts[key.to_s]["message"], 
        default: prompts[key.to_s]["default"],
        required: prompts[key.to_s]["required"] || false
    )
end

# Main
def main(argv)
    # Read arguments.
    type = argv[0].to_sym
    configPath = argv[1]

    if type.nil?
        abort("Usage: ruby generate_package.rb <type> [config path]")
    end

    # Create the config.
    config = Config.new(configPath || CONFIG_PATH, scheme: {
        :swiftToolVersion => "5.8",
        :demo => {
            :iosVersion => "16.6",
            :bundleIdentifier => nil,
            :teamIdentifier => nil,
            :displayVersion => "1.0.0",
            :buildNumber => "1",
            :appIcon => "app_icon",
            :accentColor => "accent_color",
            :additionalInfoPlistContentFilePath => nil
        },
        :package => {
            
        }
    })

    # Make queries.
    queries = makeQueries(
        type,
        YAML.load_file(PROMPT_PATH),
        required: [
            :packageName,
            :packagePath,
            :author,
        ],
        options: {
            :demo => [  
                :displayName,
                :dependencyPath    
            ],
            :package => [

            ]
        }
    )

    # Read queries from input.
    required = QueryReader.new(queries[:required]).read()
    options = QueryReader.new(queries[:options]).read()

    # Generate package.
    Generator.new(required[:packageName], required[:packagePath], required[:author])
        .generate(type, options, config)

    puts "✅ Package generation complete."
end

main(ARGV)