require 'sublime_video_private_api/engine'
require 'sublime_video_private_api/model'

module SublimeVideoPrivateApi
  def self.token
    @token ||= ENV['PRIVATE_API_PASSWORD'] || 'sublimevideo'
  end
end
