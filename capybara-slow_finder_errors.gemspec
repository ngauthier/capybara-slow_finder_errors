# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "capybara-slow_finder_errors"
  spec.version       = "0.1.0"
  spec.authors       = ["Nick Gauthier"]
  spec.email         = ["ngauthier@gmail.com"]
  spec.summary       = %q{Raises an error when you use a Capybara finder improperly}
  spec.description   = %q{If you use a finder that reaches capybara's timeout, and error is raised.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "capybara", "~> 2.0"
end
