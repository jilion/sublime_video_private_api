# SublimeVideoPrivateApi

This Rails engine provides utility for creating models & controller that can easily speach eachother alongs all SublimeVideo Rails apps.

Depends on `her`, `responders` & `kaminari` gems.

## Usage



### Client Side

Just extend your models this way:

``` ruby
class Foo
  include SublimeVideoPrivateApi::Model

  uses_private_api :www # SV app subdomain where model is located.
end
```

### Server Side

Add your controllers in `app/controllers/private_api/` this way:

``` ruby
class PrivateApi::FoosController < SublimeVideoPrivateApiController

  def index
    @foos = Foo.page(params[:page])
    respond_with(@foos)
  end

  # ...
end
```

and in your `config/routes.rb` :

``` ruby
  namespace :private_api do
    resources :foos
  end
```

### Deployement to http://gemfury.com/

Update `VERSION` in `lib/sublime_video_layout/version.rb` to `X.Y.Z` and then run the following commands:

``` bash
> bundle install
> rake build
sublime_video_private_api X.Y.Z built to pkg/sublime_video_private_api-X.Y.Z.gem
> bundle exec fury push pkg/sublime_video_private_api-X.Y.Z.gem
```

------------
Copyright (c) 2010 - 2013 Jilion(r) - SublimeVideo and Jilion are registered trademarks
