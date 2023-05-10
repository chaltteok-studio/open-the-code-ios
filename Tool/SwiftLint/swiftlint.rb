configuration = ARGV[0]
rootPath = ARGV[1]

configurations = ["Develop-Debug", "Live-Debug"]

if configurations.include?(configuration)
    # Run swift lint
    lintPath = File.expand_path("swiftlint", File.dirname(__FILE__))
    warn `#{lintPath} --config #{rootPath}/.swiftlint.yml #{rootPath}`
end