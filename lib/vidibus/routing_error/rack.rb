module Vidibus
  module RoutingError
    class Rack
      def initialize(app)
        @app = app
      end

      def call(env)
        env["action_dispatch.show_exceptions"] = false 
        @app.call(env)
      rescue => exception
        if exception.kind_of?(ActionController::RoutingError)
          env["vidibus-routing_error.exception"] = exception
          env["vidibus-routing_error.request_uri"] = env["REQUEST_URI"]
          
          # set routing_error path internally to catch route
          env["PATH_INFO"] = env["REQUEST_URI"] = "/routing_error"
        end
        env["action_dispatch.show_exceptions"] = true
        return @app.call(env)
      end
    end
  end
end
