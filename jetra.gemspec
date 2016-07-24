# coding: utf-8
$:.push File.expand_path('lib', __dir__)

require "jetra/version"

gem_files = `git ls-files -- lib/*`.split("\n")

Gem::Specification.new 'jetra',Jetra::Version do |spec|
  spec.authors       = ["Jeffrey"]
  spec.email         = ["jeffrey6052@163.com"]
  spec.description   = "micro DSL"
  spec.summary       = "make it easy to write micro service"
  spec.license       = "MIT"

  spec.files         = gem_files

end