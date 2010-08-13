$:.unshift(File.join(File.dirname(__FILE__), "..", "lib", "vidibus"))
require "routing_error/rack"

module Vidibus::RoutingError
  class Engine < ::Rails::Engine
    unless Rails.env.test?
      config.app_middleware.insert_before("ActionDispatch::ShowExceptions", "Vidibus::RoutingError::Rack")
    end
  end
end