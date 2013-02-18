$LOAD_PATH.unshift("#{Dir.pwd}/app") unless $LOAD_PATH.include?("#{Dir.pwd}/app")

require 'bundler/setup'

unless defined?(Rails)
  module Rails
    def self.root; Pathname.new(File.expand_path('')); end
    def self.env; 'test'; end
  end
end
