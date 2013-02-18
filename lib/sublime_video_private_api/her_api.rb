require 'her'

require 'sublime_video_private_api/faraday/token_authentication'
require 'sublime_video_private_api/faraday/response/headers_parser'
require 'sublime_video_private_api/faraday/response/body_parser'
require 'sublime_video_private_api/url'

module SublimeVideoPrivateApi
  class HerApi
    attr_reader :subdomain, :api

    def initialize(subdomain)
      @subdomain = subdomain.to_s
      @api = Her::API.new
      setup unless Rails.env == 'test'
    end

    def url
      @url ||= SublimeVideoPrivateApi::Url.new(subdomain).url
    end

    def ssl_options
      { ca_path: '/usr/lib/ssl/certs', verify: false }
    end

    def setup
      @api.setup url: url, ssl: ssl_options do |connection|
        connection.use SublimeVideoPrivateApi::Faraday::TokenAuthentication, token: SublimeVideoPrivateApi.token
        connection.use Her::Middleware::AcceptJSON
        connection.use SublimeVideoPrivateApi::Faraday::Response::HeadersParser
        connection.use SublimeVideoPrivateApi::Faraday::Response::BodyParser
        connection.use ::Faraday::Request::UrlEncoded
        connection.use ::Faraday::Adapter::NetHttp
      end
    end
  end
end
