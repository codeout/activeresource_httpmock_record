# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activeresource_httpmock_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'activeresource_httpmock_record'
  spec.version       = ActiveResourceHttpMockRecord::VERSION
  spec.authors       = ['Shintaro Kojima']
  spec.email         = ['goodies@codeout.net']
  spec.description   = %q{Record HTTP request and response through ActiveResource, and playback with ActiveResource::HttpMock}
  spec.summary       = %q{ActiveResource::HttpMock extenstion for testing}
  spec.homepage      = 'https://github.com/codeout/activeresource_httpmock_record'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activeresource'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
