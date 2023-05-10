#
#  copy-license.rb
#
#
#  Created by JSilver on 2023/04/25.
#

# Constant
OUTPUT_DIRECTORY = "License"
LICENSE_FILENAME = "LICENSE"

# Functions
def copyLicense(packagePath, outputPath)
    outputPath = "#{outputPath}/#{OUTPUT_DIRECTORY}"
    # Remove old LICENSE files.
    `rm -rf #{outputPath}`
    # Create LICENSE directory if needed.
    `mkdir #{outputPath} 2>&1`

    # Read all LICENSE file from packages.
    licenses = Dir["#{packagePath}/**/#{LICENSE_FILENAME}"]
    licenses.each do |license|
        directory = File.dirname(license)
        package = File.basename(directory)
        
        puts "📄 Copying #{package} LICENSE."
        # Copy LICENSE file to output path.
        `cp -Rf #{license} #{outputPath}/#{package}`
        `chmod 666 #{outputPath}/#{package}`
    end
end

# Main
def main(argv)
    # Get arguments
    packagePath = ARGV[0]
    outputPath = ARGV[1]

    puts packagePath
    puts outputPath

    if packagePath.nil? || outputPath.nil?
        abort("Usage: ruby copy-license <package path> <output path>")
    end

    copyLicense(packagePath, outputPath)
end

main(ARGV)