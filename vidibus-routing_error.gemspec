# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'vidibus/routing_error/version'

Gem::Specification.new do |s|
  s.name        = 'vidibus-routing_error'
  s.version     = Vidibus::RoutingError::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Andre Pankratz'
  s.email       = 'andre@vidibus.com'
  s.homepage    = 'https://github.com/vidibus/vidibus-routing_error'
  s.summary     = 'Catches ActionController::RoutingError in Rails 3'
  s.description = 'Catches ActionController::RoutingError and sends it to a custom method.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'vidibus-routing_error'

  s.add_development_dependency 'bundler', '>= 1.0.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'

  s.files = Dir.glob('{lib,app,config}/**/*') + %w[LICENSE README.rdoc Rakefile]
  s.require_path = 'lib'
end
