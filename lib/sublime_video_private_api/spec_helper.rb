require 'her'
require 'timecop'
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

        connection.use :http_cache, store: SublimeVideoPrivateApi.cache_store

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

# This example the following variables to be defined in its context:
#  - url => the url to GET
#  - expected_last_modified => the first expected 'Last-Modified' (unless the :cache_validation option is set to false)
#    thus, stale the next response
#
# @note You can omit `expected_last_modified` if you set the
#   `:cache_validation` to false
#
shared_examples 'valid caching headers' do |opts = {}|
  it 'responds with the right caching headers depending on the request headers' do
    options = { cache_control: 'max-age=120, public', cache_validation: true }.merge(opts)
    get url, {}, @env

    expect(response.status).to eq 200
    expect(response.headers['Cache-Control']).to eq options[:cache_control]
    if options[:cache_validation]
      expect(etag = response.headers['ETag']).to be_present
      expect(last_modified = response.headers['Last-Modified']).to eq record.updated_at.httpdate

      Timecop.travel(5.seconds.from_now) do
        # Conditional request
        @env.merge!('HTTP_IF_NONE_MATCH' => etag, 'HTTP_IF_MODIFIED_SINCE' => last_modified)
        get url, {}, @env

        expect(response.status).to eq 304
        expect(response.headers['Cache-Control']).to eq options[:cache_control]
        expect(response.headers['ETag']).to eq etag
        expect(response.headers['Last-Modified']).to eq last_modified

        # Make the resource staled
        record.touch

        get url, {}, @env
        expect(response.status).to eq 200
        expect(response.headers['Cache-Control']).to eq options[:cache_control]
        expect(response.headers['ETag']).not_to eq etag
        expect(response.headers['Last-Modified']).not_to eq last_modified
      end
    end
  end
end
