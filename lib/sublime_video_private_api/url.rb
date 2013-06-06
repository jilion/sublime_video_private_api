require 'sublime_video_private_api'

module SublimeVideoPrivateApi
  class Url
    def initialize(subdomain)
      @subdomain = subdomain.to_s
    end

    def url
      scheme + [subdomain, host].compact.join('.') + '/private_api'
    end

    private

    def subdomain
      return nil if SublimeVideoPrivateApi.env == 'test'

      @subdomain == 'www' ? nil : @subdomain
    end

    def host
      case SublimeVideoPrivateApi.env
      when 'development' then 'sublimevideo.dev'
      when 'production'  then 'sublimevideo.net'
      when 'staging'     then 'sublimevideo-staging.net'
      when 'test'        then 'example.com'
      end
    end

    def scheme
      case SublimeVideoPrivateApi.env
      when 'development', 'test'   then 'http://'
      when 'production', 'staging' then 'https://'
      end
    end
  end
end
