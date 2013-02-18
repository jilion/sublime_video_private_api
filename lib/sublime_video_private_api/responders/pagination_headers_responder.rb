module SublimeVideoPrivateApi
  module Responders
    module PaginationHeadersResponder

      def initialize(controller, resources, options = {})
        super
        @options = options
      end

      def to_format
        add_pagination_headers!
        super
      end

    private

      def add_pagination_headers!
        return unless paginated_resource?
        set_headers
      end

      def paginated_resource?
        resource.respond_to?(:current_page)
      end

      def set_headers
        set_header('X-Page',        resource.current_page)
        set_header('X-Offset',      resource.offset_value)
        set_header('X-Limit',       resource.limit_value)
        set_header('X-Total-Count', resource.total_count)
      end

      def set_header(header_name, value)
        controller.response.headers[header_name] = value.to_s
      end

    end
  end
end
