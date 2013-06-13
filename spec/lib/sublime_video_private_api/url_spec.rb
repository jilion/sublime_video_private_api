require 'fast_spec_helper'

require 'sublime_video_private_api/url'

describe SublimeVideoPrivateApi::Url do

  context "development Rails.env" do
    before { Rails.stub(:env) { 'development' } }

    context "www subdomain" do
      subject { SublimeVideoPrivateApi::Url.new('www') }
      its(:url) { should eq 'http://sublimevideo.dev/private_api' }
    end

    context "my subdomain" do
      subject { SublimeVideoPrivateApi::Url.new('my') }
      its(:url) { should eq 'http://my.sublimevideo.dev/private_api' }
    end

    context "my subdomain with MY_PRIVATE_API_ENV=production" do
      subject { SublimeVideoPrivateApi::Url.new('my') }
      before { ENV["MY_PRIVATE_API_ENV"] = 'production' }
      its(:url) { should eq 'https://my.sublimevideo.net/private_api' }
      after { ENV["MY_PRIVATE_API_ENV"] = nil }
    end
  end

  context "production Rails.env" do
    before { Rails.stub(:env) { 'production' } }

    context "my subdomain" do
      subject { SublimeVideoPrivateApi::Url.new('my') }
      its(:url) { should eq 'https://my.sublimevideo.net/private_api' }
    end
  end

  context "staging Rails.env" do
    before { Rails.stub(:env) { 'staging' } }

    context "my subdomain" do
      subject { SublimeVideoPrivateApi::Url.new('my') }
      its(:url) { should eq 'https://my.sublimevideo-staging.net/private_api' }
    end
  end

  context "test Rails.env" do
    before { Rails.stub(:env) { 'test' } }

    context "www subdomain" do
      subject { SublimeVideoPrivateApi::Url.new('my') }
      its(:url) { should eq 'http://example.com/private_api' }
    end

    context "my subdomain" do
      subject { SublimeVideoPrivateApi::Url.new('my') }
      its(:url) { should eq 'http://example.com/private_api' }
    end
  end

end
