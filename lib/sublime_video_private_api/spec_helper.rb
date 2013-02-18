require 'her'

require 'sublime_video_private_api/faraday/response/headers_parser'
require 'sublime_video_private_api/faraday/response/body_parser'
require 'sublime_video_private_api/url'

module SublimeVideoPrivateApi
  module SpecHelper
    def stub_api_for(klass)
      api = Her::API.new
      klass.uses_api(api)
      api.setup url: SublimeVideoPrivateApi::Url.new('www').url do |connection|
        connection.use Her::Middleware::AcceptJSON
        connection.use SublimeVideoPrivateApi::Faraday::Response::HeadersParser
        connection.use SublimeVideoPrivateApi::Faraday::Response::BodyParser
        connection.use ::Faraday::Request::UrlEncoded
        connection.use ::Faraday::Adapter::NetHttp
        connection.adapter(:test) { |s| yield(s) }
      end
    end

    def set_api_credentials
      credentials = ActionController::HttpAuthentication::Token.encode_credentials(
        SublimeVideoPrivateApi.token)
      @env ||= {}
      @env['HTTP_AUTHORIZATION'] = credentials
    end
  end
end
