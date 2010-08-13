$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "active_support/core_ext"
require "spec"
require "rr"
require "vidibus-routing_error"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
