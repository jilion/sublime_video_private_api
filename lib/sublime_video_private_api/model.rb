require 'active_support/concern'
require 'kaminari'
require 'kaminari/models/array_extension'
require 'sublime_video_private_api/her_api'

module SublimeVideoPrivateApi
  module Model
    extend ActiveSupport::Concern

    include ActiveModel::Conversion
    include Her::Model

    included do
      extend ActiveModel::Naming
    end

    module ClassMethods
      def uses_private_api(subdomain)
        uses_api HerApi.new(subdomain).api
      end

      def all(params = {})
        results = super(params)
        Kaminari.paginate_array(
          results,
          limit: results.metadata[:limit],
          offset: results.metadata[:offset],
          total_count: results.metadata[:total_count]).page(params[:page])
      end

      def find_each(params = {})
        per_page = params.delete(:batch_size) || 1000
        page     = 1

        begin
          records = all(params.merge(per: per_page, page: page))
          records.each { |r| yield(r) }
          page += 1
        end until records.size < per_page
      end

      def count(params = {})
        all(params).total_count
      end

      def find(*ids)
        super(*ids)
      rescue ::Faraday::Error::ResourceNotFound
        raise ActiveRecord::RecordNotFound
      end
    end

    def created_at
      @created_at ||= Time.parse(@data[:created_at])
    end

    def updated_at
      @created_at ||= Time.parse(@data[:created_at])
    end

    def persisted?
      !new?
    end

  end
end
