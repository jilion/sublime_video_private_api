require 'her'

require 'faraday-http-cache'
require 'sublime_video_private_api/faraday/response/headers_parser'
require 'sublime_video_private_api/faraday/response/body_parser'
require 'sublime_video_private_api/url'

module SublimeVideoPrivateApi
  class HerApi
    attr_reader :subdomain, :api

    def initialize(subdomain)
      @subdomain = subdomain.to_s
      @api = Her::API.new
      setup unless SublimeVideoPrivateApi.env == 'test'
    end

    def url
      @url ||= SublimeVideoPrivateApi::Url.new(subdomain).url
    end

    def ssl_options
      { ca_path: '/usr/lib/ssl/certs', verify: false }
    end

    def setup
      @api.setup url: url, ssl: ssl_options do |connection|
        connection.request :token_auth, SublimeVideoPrivateApi.token
        connection.use Her::Middleware::AcceptJSON
        connection.request :url_encoded # form-encode POST params

        connection.response :raise_error
        connection.response :headers_parser
        connection.response :body_parser

        connection.use :http_cache, store: SublimeVideoPrivateApi.cache_store

        connection.adapter :net_http
      end
    end
  end
end
