lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'demand/version'

Gem::Specification.new do |spec|
    spec.name          = 'demand'
    spec.version       = Demand::VERSION
    spec.authors       = ['Convincible']
    spec.email         = ['development@convincible.media']

    spec.summary       = "Return a variable if it's present (and optionally of the right type), otherwise a default or nil. Adds a top level demand() method."
    spec.description   = "Return a variable if it's present (and optionally of the right type), otherwise a default or nil. Adds a top level demand() method, which replaces long lines of repetitive code to check for nil?/present?/empty?, etc., hard-to-read ternary operators (?:) and if statements. A block can also be specified, which only runs (with the variable) if the checks pass."
    spec.homepage      = 'https://github.com/ConvincibleMedia/ruby-gem-demand'

    spec.files         = Dir['lib/**/*.rb']
    spec.required_ruby_version = '>= 2.5.0'

    spec.add_dependency 'activesupport', '~>5.2.2'
    spec.add_dependency 'boolean', '~>1.0'

    spec.add_development_dependency "bundler", "~> 2.0"
    spec.add_development_dependency "rake", "~> 12.0"
    spec.add_development_dependency "rspec", "~> 3.0"
    #spec.add_development_dependency "ice_nine"
    spec.add_development_dependency "pry"
    spec.add_development_dependency "pry-nav"
end
