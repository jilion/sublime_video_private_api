module SublimeVideoPrivateApi
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    config.action_dispatch.rescue_responses["Faraday::Error::ResourceNotFound"] = :not_found
  end
end
