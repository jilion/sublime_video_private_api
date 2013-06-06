require 'sublime_video_private_api/engine' if defined?(Rails) && defined?(Rails::Engine)
require 'sublime_video_private_api/model'

module SublimeVideoPrivateApi
  def self.env
    @@_env ||= if _rails?
      Rails.env
    else
      ENV['RAILS_ENV'] || ENV['RACK_ENV']
    end
  end

  def self.cache_store
    @@_cache_store ||= if _rails?
      Rails.cache
    else
      _detect_first_cache_store([:dalli_store, :mem_cache_store, :memory_store])
    end
  end

  def self.token
    @@_token ||= ENV['PRIVATE_API_PASSWORD'] || 'sublimevideo'
  end

  def self._rails?
    @@_rails ||= defined? Rails
  end

  def self._detect_first_cache_store(stores)
    stores.each do |store|
      return store if _detect_cache_store(store)
    end

    false
  end

  def self._detect_cache_store(store)
    begin
      require "active_support/cache/#{store}"
    rescue LoadError
      false
    else
      true
    end
  end
end
