$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'sublime_video_private_api/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'sublime_video_private_api'
  s.version     = SublimeVideoPrivateApi::VERSION
  s.authors     = ['Thibaud Guillaume-Gentil', 'Rémy Coutable']
  s.email       = ['thibaud@jilion.com', 'remy@jilion.com']
  s.homepage    = 'https://github.com/jilion/sublime_video_private_api'
  s.summary     = 'Private API utility engine for SublimeVideo applications.'
  s.description = 'Private API utility engine for SublimeVideo applications, especially models & controller'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w[Rakefile README.md]
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'activesupport',      '>= 3.2'
  s.add_dependency 'her',                '~> 0.6.1'
  s.add_dependency 'faraday-http-cache', '~> 0.2.0'
  s.add_dependency 'multi_json'
  s.add_dependency 'kaminari'
  s.add_dependency 'responders'
  s.add_dependency 'timecop'
  s.add_dependency 'rescue_me'

  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
end
