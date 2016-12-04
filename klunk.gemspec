# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'klunk/version'

Gem::Specification.new do |spec|
  spec.name          = 'klunk'
  spec.version       = Klunk::VERSION
  spec.authors       = ['Marco Antonio Gonzalez Junior', 'Wagner Vaz']
  spec.email         = ['kayaman.baurets@gmail.com', 'wv@0xd.co']

  spec.summary       =  'Enterprise Messaging System on Rails'
  spec.description   =  'Enterprise Messaging System on Rails'
  spec.homepage      = 'https://github.com/kayaman/klunk'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 2'
  spec.add_runtime_dependency 'safe_yaml'
  spec.add_runtime_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
