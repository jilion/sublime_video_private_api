require 'faraday'
require 'active_support/core_ext'
require 'multi_json'

module SublimeVideoPrivateApi
  module Faraday
    module Response

      class BodyParser < ::Faraday::Response::Middleware
        ::Faraday.register_middleware :response, body_parser: BodyParser

        def on_complete(env)
          env[:body] = _parse_body(env[:body])
        end

        private

        def _parse_body(body)
          default_body = {
            data: {},
            errors: {},
            metadata: {}
          }
          if body.present? && (json = MultiJson.load(body, symbolize_keys: true))
            default_body[:errors]   = json.delete(:errors) if json.include?(:errors)
            default_body[:metadata] = json.delete(:metadata) if json.include?(:metadata)
            default_body[:data]     = json
          end

          default_body
        end
      end

    end
  end
end
