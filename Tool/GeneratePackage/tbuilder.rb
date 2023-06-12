require 'fileutils'
require 'pathname'
require 'erb'

# TBuilder
class TBuilder
    # Property

    # Initializer
    def initialize(template)
        @template = template
    end

    # Public
    def build(to:, data:)
        outputPath = to

        # Copy template files.
        FileUtils.cp_r(@template, outputPath) 

        # Build files from template files.
        templatePaths = Dir["#{outputPath}/**/*.erb"]
        templatePaths.each do |templatePath|
            # Read ERB template file.
            template = ERB.new(File.read(templatePath), trim_mode: "-")
            # Create file from template.
            File.write(
                Pathname.new(File.dirname(templatePath)) / Pathname.new(File.basename(templatePath, '.erb')),
                template.result(binding)
            )
            # Remove ERB template file.
            File.delete(templatePath)
        end
    end

    # Private
    private
end
