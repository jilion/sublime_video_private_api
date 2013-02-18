module SublimeVideoPrivateApi
  module Faraday
    class TokenAuthentication < ::Faraday::Middleware
      def initialize(app, options = {})
        @app = app
        @options = options
      end

      def call(env)
        env[:request_headers]["AUTHORIZATION"] = "Token token=\"#{@options[:token]}\"" if @options.include?(:token)
        @app.call(env)
      end
    end
  end
end
