# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "crystalmq"
  spec.version       = "0.0.1"
  spec.authors       = ["Martin Simpson"]
  spec.email         = ["martin.c.simpson@gmail.com"]

  spec.summary       = "Crystal Message Queue Ruby Client"
  spec.description   = "A Client for the Crystal Message Queue written in Ruby"
  spec.homepage      = "http://crystalmq.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'msgpack'
end
