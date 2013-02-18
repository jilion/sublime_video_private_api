module SublimeVideoPrivateApi
  module Faraday
    module Response
      class BodyParser < ::Faraday::Response::Middleware
        def on_complete(env)
          env[:body] = parse_body(env[:body])
        end

        private

        def parse_body(body)
          default_body = {
            :data => {},
            :errors => {},
            :metadata => {}
          }
          if body.present?
            json = MultiJson.load(body, symbolize_keys: true)
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
