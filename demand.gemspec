
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'demand/version'

Gem::Specification.new do |spec|
    spec.name          = 'demand'
    spec.version       = Demand::VERSION
    spec.authors       = ['Convincible']
    spec.email         = ['development@convincible.media']

    spec.summary       = "Adds a top level demand(variable) method to return a variable if it's present and optionally of the right type. Otherwise, a default or nil is returned."
    spec.description   = "Adds a top level demand(variable) method to return a variable if it's present and optionally of the right type. Otherwise, a default or nil is returned. demand() replaces long lines of repetitive code to check for nil?/present?/empty?, etc., hard-to-read ternary operators (?:) and if statements. A block can also be specified, which only runs (with the variable) if the checks pass."
    spec.homepage      = 'https://github.com/ConvincibleMedia/ruby-gem-demand'

    # Specify which files should be added to the gem when it is released.
    # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
    spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
        `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    end
    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ['lib']

    spec.add_dependency 'active_support'
    spec.add_dependency 'boolean'

    spec.add_development_dependency 'pry', '~> 0.12'
    spec.add_development_dependency 'bundler', '~> 1.17'
    spec.add_development_dependency 'rake', '~> 10.0'
    spec.add_development_dependency 'rspec', '~> 3.0'
end
