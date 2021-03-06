# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svg_geometry/version'

Gem::Specification.new do |spec|
  spec.name          = "svg_geometry"
  spec.version       = SvgGeometry::VERSION
  spec.authors       = ["Alan Gomes"]
  spec.email         = ["alan@ubee.in"]
  spec.description   = "Ruby Svg Geometry Gem"
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|benchmark|visualization_tests|phantomjs)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '1.9.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "ruby-prof"
  spec.add_development_dependency "cairo"
  spec.add_development_dependency "nokogiri"
end
