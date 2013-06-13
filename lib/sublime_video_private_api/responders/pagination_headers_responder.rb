module SublimeVideoPrivateApi
  module Responders
    module PaginationHeadersResponder

      def initialize(controller, resources, options = {})
        super
        @options = options
      end

      def to_format
        _add_pagination_headers!
        super
      end

    private

      def _add_pagination_headers!
        return unless _paginated_resource?
        _set_headers
      end

      def _paginated_resource?
        resource.respond_to?(:current_page)
      end

      def _set_headers
        _set_header('X-Page',        resource.current_page)
        _set_header('X-Offset',      resource.offset_value)
        _set_header('X-Limit',       resource.limit_value)
        _set_header('X-Total-Count', resource.total_count)
      end

      def _set_header(header_name, value)
        controller.response.headers[header_name] = value.to_s
      end

    end
  end
end
