require 'responders'
require 'sublime_video_private_api/responders/pagination_headers_responder'

class SublimeVideoPrivateApiController < ActionController::Base
  respond_to :json

  before_filter :authenticate

  responders SublimeVideoPrivateApi::Responders::PaginationHeadersResponder

  if defined? ActiveRecord
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      token == SublimeVideoPrivateApi.token
    end
  end

  def record_not_found
    render request.format.ref => { error: 'Resource could not be found.' }, status: 404
  end
end
