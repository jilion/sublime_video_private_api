# SublimeVideoPrivateAPI

This Rails engine provides utility for creating models & controller that can easily speach eachother alongs all SublimeVideo Rails apps.

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
