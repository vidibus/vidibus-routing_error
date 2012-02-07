Rails.application.routes.draw do
  match 'routing_error' => 'routing_error#rescue'
end
