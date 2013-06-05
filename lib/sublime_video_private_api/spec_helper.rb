require 'her'
require 'faraday-http-cache'
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
        connection.request :url_encoded # form-encode POST params

        connection.response :raise_error
        connection.response :headers_parser
        connection.response :body_parser

        connection.use :http_cache, SublimeVideoPrivateApi.cache_store

        connection.adapter(:test) { |s| yield(s) }
      end
    end

    def set_api_credentials
      credentials = ActionController::HttpAuthentication::Token.encode_credentials(SublimeVideoPrivateApi.token)
      @env ||= {}
      @env['HTTP_AUTHORIZATION'] = credentials
    end
  end
end
