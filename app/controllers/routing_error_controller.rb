class RoutingErrorController < ApplicationController

  # Re-raise routing_error that has been catched in rack app.
  # To rescue this error, use default actions:
  #
  #   rescue_from ActionController::RoutingError, :with => :rescue_404
  #   def rescue_404
  #     # do something
  #   end
  #
  def rescue
    env["REQUEST_URI"] = env["vidibus-routing_error.request_uri"]
    raise ActionController::RoutingError, "No route matches #{env["REQUEST_URI"].inspect}"
  end
end