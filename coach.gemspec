
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "coach/version"

Gem::Specification.new do |spec|
  spec.name          = "coach"
  spec.version       = Coach::VERSION
  spec.authors       = ["Gideao Santana"]
  spec.email         = ["hello@gideao.co"]

  spec.summary       = %q{"A set of tools help handle URI Online Judge's problems.}
  spec.description   = %q{Tools for automate commons task when solving  URI Online Judge's problems}
  spec.homepage      = "https://github.com/gideao/coach"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"

  spec.add_dependency 'sqlite3', '~> 1.3', '>= 1.3.11'
  spec.add_dependency 'sequel', '~> 5.5'
  spec.add_dependency 'thor', '~> 0.20'
  spec.add_dependency 'tty-command', ~> '0.7'
end
