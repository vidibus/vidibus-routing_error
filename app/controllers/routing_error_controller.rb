class RoutingErrorController < ApplicationController

  # Re-raise routing_error that has been catched in rack app.
  # To rescue this error, use default actions:
  #
  #   rescue_from ActionController::RoutingError, :with => :my_404_rescue
  #   def my_404_rescue
  #     # do something
  #   end
  #
  def rescue
    env["REQUEST_URI"] = env["vidibus-routing_error.request_uri"]
    raise env["vidibus-routing_error.exception"]
  end
end