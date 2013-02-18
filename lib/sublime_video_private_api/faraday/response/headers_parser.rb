module SublimeVideoPrivateApi
  module Faraday
    module Response
      class HeadersParser < ::Faraday::Response::Middleware
        def on_complete(env)
          env[:body] = parse_headers(env)
        end

        private

        def parse_headers(env)
          env[:response_headers].tap do |headers|
            env[:body][:metadata][:page] = headers['X-Page'].to_i if headers.include?('X-Page')
            env[:body][:metadata][:limit] = headers['X-Limit'].to_i if headers.include?('X-Limit')
            env[:body][:metadata][:offset] = headers['X-Offset'].to_i if headers.include?('X-Offset')
            env[:body][:metadata][:total_count] = headers['X-Total-Count'].to_i if headers.include?('X-Total-Count')
          end
          env[:body]
        end
      end
    end
  end
end
