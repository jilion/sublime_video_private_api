require 'sublime_video_private_api/engine' if defined?(Rails) && defined?(Rails::Engine)
require 'sublime_video_private_api/model'

module SublimeVideoPrivateApi
  def self.env
    if defined? Rails
      Rails.env
    else
      ENV['RAILS_ENV'] || ENV['RACK_ENV']
    end
  end

  def self.token
    @token ||= ENV['PRIVATE_API_PASSWORD'] || 'sublimevideo'
  end
end
