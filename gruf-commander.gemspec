# frozen_string_literal: true

# Copyright (c) 2018-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gruf/commander/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-commander'
  spec.version       = Gruf::Commander::VERSION
  spec.authors       = ['Shaun McCormick']
  spec.email         = ['splittingred@gmail.com']

  spec.summary       = 'Command/request syntax helper for gruf'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/bigcommerce/gruf-commander'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-commander.gemspec']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_development_dependency 'bundler-audit', '>= 0.6'
  spec.add_development_dependency 'factory_bot', '>= 5.0'
  spec.add_development_dependency 'ffaker', '>= 2.8'
  spec.add_development_dependency 'pry', '>= 0.12'
  spec.add_development_dependency 'pry-byebug', '>= 3.9'
  spec.add_development_dependency 'rspec', '>= 3.8'
  spec.add_development_dependency 'rspec_junit_formatter', '>= 0.4'
  spec.add_development_dependency 'rubocop', '>= 1.4'
  spec.add_development_dependency 'rubocop-performance', '>= 0.0.1'
  spec.add_development_dependency 'rubocop-rspec', '>= 2.0'
  spec.add_development_dependency 'rubocop-thread_safety', '>= 0.3'
  spec.add_development_dependency 'simplecov', '>= 0.15'

  spec.add_runtime_dependency 'activemodel', '> 4'
  spec.add_runtime_dependency 'gruf', '>= 2.4'
end
