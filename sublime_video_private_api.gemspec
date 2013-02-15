$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sublime_video_private_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sublime_video_private_api"
  s.version     = SublimeVideoPrivateApi::VERSION
  s.authors     = ["Jilion"]
  s.email       = ["info@jilion.com"]
  s.homepage    = "http://jilion.com"
  s.summary     = "Private API utility Rails engine for SublimeVideo applications."
  s.description = "Private API utility Rails engine for SublimeVideo applications, especially models & controller"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'

end
