require 'responders'
require 'sublime_video_private_api/responders/pagination_headers_responder'

class SublimeVideoPrivateApiController < ActionController::Base
  respond_to :json
  before_filter :authenticate
  responders SublimeVideoPrivateApi::Responders::PaginationHeadersResponder

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      token == SublimeVideoPrivateApi.token
    end
  end
end
