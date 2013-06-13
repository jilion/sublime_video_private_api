require 'faraday'
require 'active_support/core_ext'

module SublimeVideoPrivateApi
  module Faraday
    module Response

      class HeadersParser < ::Faraday::Response::Middleware
        ::Faraday.register_middleware :response, headers_parser: HeadersParser

        def on_complete(env)
          env[:body] = _parse_headers(env)
        end

        private

        def _parse_headers(env)
          env[:response_headers].tap do |headers|
            %w[Page Limit Offset Total-Count].each do |data|
              if headers.include?("X-#{data}")
                env[:body][:metadata][data.underscore.to_sym] = headers["X-#{data}"].to_i
              end
            end
          end
          env[:body]
        end
      end

    end
  end
end
