Rails.application.routes.draw do |map|
  match "routing_error" => "routing_error#rescue"
end