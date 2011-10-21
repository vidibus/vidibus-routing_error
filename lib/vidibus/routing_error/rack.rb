module Vidibus
  module RoutingError
    class Rack
      def initialize(app)
        @app = app
      end

      def call(env)
        response = @app.call(env)
        status, headers, body = response
        if headers['X-Cascade'] == 'pass'
          env["vidibus-routing_error.request_uri"] = env["REQUEST_URI"]
          env["PATH_INFO"] = env["REQUEST_URI"] = "/routing_error"
          @app.call(env)
        else
          response
        end
      end
    end
  end
end
