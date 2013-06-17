require 'spec_helper'

describe 'Server' do

  context 'unauthenticated' do
    it "returns 401" do
      get 'private_api/foos.json', {}, @env
      response.status.should eq 401
    end
  end

  context 'authenticated' do
    before { set_api_credentials }

    describe "index" do
      let(:url) { 'private_api/foos.json' }
      it_behaves_like 'valid caching headers', cache_validation: false

      it "returns 200" do
        get url, {}, @env
        response.status.should eq 200
      end

      it "sets pagination headers" do
        get url, {}, @env
        response.headers['X-Page'].should eq '1'
        response.headers['X-Limit'].should eq '25'
        response.headers['X-Offset'].should eq '0'
        response.headers['X-Total-Count'].should eq '0'
      end
    end

    describe "show" do
      let(:foo) { create(:foo) }
      let(:url) { "private_api/foos/#{foo.id}.json" }

      it_behaves_like 'valid caching headers' do
        let(:record) { foo }
      end

      it "returns 200" do
        get url, {}, @env
        response.status.should eq 200
      end
    end
  end
end
