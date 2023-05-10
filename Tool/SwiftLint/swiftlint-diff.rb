SWIFTLINT_PATH = ARGV[0]
EXTRA_COMMAND = ARGV[1]

# Exit if swiftlint not found.
if SWIFTLINT_PATH.nil? || !File.exist?(SWIFTLINT_PATH)
    puts "⚠️ swiftlint not found."
    exit(1)
end

INCLUDE_FILE_EXT_REGEX = ".swift$"

# 
modifiedFiles = `git diff --name-only | grep '#{INCLUDE_FILE_EXT_REGEX}'`
unstagedFiles = `git ls-files --other --exclude-standard | grep '#{INCLUDE_FILE_EXT_REGEX}'`

# Make file list qury parameter.
files = (modifiedFiles + unstagedFiles).gsub("\n", ' ')

if EXTRA_COMMAND.nil?
    puts `#{SWIFTLINT_PATH} -- #{files}`
elsif
    puts `#{SWIFTLINT_PATH} #{EXTRA_COMMAND} -- #{files}`
end