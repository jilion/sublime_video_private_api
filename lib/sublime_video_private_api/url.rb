require 'sublime_video_private_api'

module SublimeVideoPrivateApi
  class Url
    attr_accessor :subdomain

    def initialize(subdomain)
      @subdomain = subdomain.to_s
    end

    def url
      _scheme + [_subdomain, _host].compact.join('.') + '/private_api'
    end

    private

    def _subdomain
      return nil if _env == 'test'
      subdomain == 'www' ? nil : subdomain
    end

    def _host
      case _env
      when 'development' then 'sublimevideo.dev'
      when 'production'  then 'sublimevideo.net'
      when 'staging'     then 'sublimevideo-staging.net'
      when 'test'        then 'example.com'
      end
    end

    def _scheme
      case _env
      when 'development', 'test'   then 'http://'
      when 'production', 'staging' then 'https://'
      end
    end

    def _env
      @env ||= ENV["#{subdomain.upcase}_PRIVATE_API_ENV"] || SublimeVideoPrivateApi.env
    end
  end
end
