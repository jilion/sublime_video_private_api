$LOAD_PATH.unshift("#{Dir.pwd}/app") unless $LOAD_PATH.include?("#{Dir.pwd}/app")

require 'bundler/setup'

unless defined?(Rails)
  module Rails
    def self.root; Pathname.new(File.expand_path('')); end
    def self.env; 'test'; end
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_including focus: true
  config.mock_with :rspec
  config.fail_fast = ENV['FAST_FAIL'] != 'false'
  config.order = ENV['ORDER'] || 'random'

  config.before do
    SublimeVideoPrivateApi.class_variable_set(:@@_env, nil)
  end
end
