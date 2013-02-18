ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

require 'factory_girl_rails'
RSpec.configuration.include(FactoryGirl::Syntax::Methods)

module HerHelpers
  def stub_api_for(klass)
    api = Her::API.new
    klass.uses_api(api)
    api.setup url: SublimeVideoPrivateApi::Url.new('www').url do |connection|
      connection.use Her::Middleware::AcceptJSON
      connection.use SublimeVideoPrivateApi::Faraday::Response::HeadersParser
      connection.use SublimeVideoPrivateApi::Faraday::Response::BodyParser
      connection.use Faraday::Request::UrlEncoded
      connection.use Faraday::Adapter::NetHttp
      connection.adapter(:test) { |s| yield(s) }
    end
  end
end
RSpec.configuration.include(HerHelpers)

module ApiAuthHelper
  def set_api_auth_token
    credentials = ActionController::HttpAuthentication::Token.encode_credentials(
      SublimeVideoPrivateApi.token)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = credentials
  end
end
RSpec.configuration.include(ApiAuthHelper)
