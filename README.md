# Vidibus::RoutingError

Catches ActionController::RoutingError which does not work with Rails 3
out of the box. It basically catches the exception on Rack-level and
re-raises it on application-level.

This gem is part of [Vidibus](http://vidibus.org), an open source toolset
for building distributed (video) applications.


## Deprecation Warning

It is not advised to use this gem anymore. At least with Rails 3.2 it won't
work. Please implement one of the following alternatives instead:

### Alternative One

José Valim [revealed a "hidden" feature](http://blog.plataformatec.com.br/2012/01/my-five-favorite-hidden-features-in-rails-3-2/)
of Rails 3.2 that comes in handy. In Rails 3.2 you're able to define your 
own app for handling exceptions that happen in the rack stack. Thus you 
could set your own router to handle that in `application.rb`:

```ruby
config.exceptions_app = self.routes
```

Since your router is now responsible for dealing with all exceptions, you 
could define a route that handles 404s:

```ruby
match '/404', :to => 'errors#not_found'
```

### Alternative Two

Another possibility is to add a catch-all route. But don't put it just at the 
end of `routes.rb` because that will disable all routes defined by engines that
come with gems and such. Instead, append the route in `application.rb`:

```ruby
module PutYourApplicationNameHere
  class Application < Rails::Application
    # Catch 404s
    config.after_initialize do |app|
      app.routes.append{match '*path', :to => 'errors#not_found'}
    end
  end
end
```


## Addressed Problem

Since Rails 3 is based on Rack, catching a 404 error in your Application
controller does not work as expected. The underlying problem is discussed
[here](https://rails.lighthouseapp.com/projects/8994/tickets/4444-can-no-longer-rescue_from-actioncontrollerroutingerror).


## Installation

Add the dependency to the Gemfile of your application:

```ruby
gem 'vidibus-routing_error'
```

Then call bundle install on your console.


## Usage

With this gem installed, you are able to handle errors like in past versions
of Rails:

```ruby
class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, :with => :rescue_404

  def rescue_404
    # do something
    # IMPORTANT: If you modify this method, you have to restart the server.
  end
end
```

Keep in mind that you have to restart your server when changing the rescue-method!


## Underlying Mechanics

This gem implants the middleware `Vidibus::RoutingError::Rack` into your Rails stack
right after `ActionDispatch::ShowExceptions` which returns a 404 response if no
matching route was found for the current request.

`Vidibus::RoutingError::Rack` catches the 404 status and redirects internally to the route
`'/routing_error'` which is provided by this gem.

Through this route the method `RoutingErrorController#rescue` gets called which then raises
an `ActionController::RoutingError` on application level so you can rescue this error.


### Custom controller for error handling

If you want to handle the error in a specific controller, you can also route the path
`'/routing_error'` in `routes.rb` to it:

```ruby
match 'routing_error' => 'my_controller#rescue_404'
```

The failing URI will be available in the environment variable:

```ruby
env['vidibus-routing_error.request_uri']
```


## Possible Issues

### Catch-all Route

If your application has a catch-route in `routes.rb`, this gem won't work, because
routes provided by engines will be added after any existing routes. If you don't
need a catch-all route for other purposes than rescuing from routing errors, you can
savely remove it.


### Class Caching

Depending on the structure of your application, you might get an error in development
like this:

```
TypeError (User can't be referred)
```

This error is caused by some caching-reloading madness: The middleware implanted by
this gem is cached. But in development, your classes usually aren't. Thus some classes
may not be available under certain circumstances, e.g. if you are using before filters
for user authentication provided by some engine. You should be able to get rid of
the error above by turning on class caching. Try it (and restart the server afterwards):

```ruby
# development.rb
config.cache_classes = true
```

If the error is gone, you're lucky as I am. But since it is not feasible to cache classes
in development, turn off class caching again and explicitly require the class that couldn't
be referred. In my case, it's the user class:

```ruby
# top of development.rb
require 'app/models/user'
```

## Copyright

&copy; 2010-2012 Andre Pankratz. See LICENSE for details.


## Thank you!

The development of this gem was sponsored by Käuferportal: http://www.kaeuferportal.de
