# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twingly/url_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "twingly-url_cache"
  spec.version       = Twingly::UrlCache::VERSION
  spec.authors       = ["Twingly AB"]
  spec.email         = ["dev@twingly.com"]

  spec.summary       = %q{URL cache, remember if an URL been seen before}
  spec.description   = %q{Caches URL hashes in Memcached}
  spec.homepage      = "https://github.com/twingly/twingly-url_cache"

  spec.files         = Dir.glob("{lib}/**/*") + %w(README.md)
  spec.require_paths = ["lib"]

  spec.add_dependency "dalli", "~> 3.2.3"
  spec.add_dependency "retryable", "~> 2.0"

  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "pry", "~> 0"
end
