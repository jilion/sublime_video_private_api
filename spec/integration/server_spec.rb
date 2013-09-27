require 'spec_helper'

describe 'Server' do

  context 'unauthenticated' do
    it "returns 401" do
      get 'private_api/foos.json', {}, @env
      expect(response.status).to eq 401
    end
  end

  context 'authenticated' do
    before { set_api_credentials }

    describe "index" do
      let(:url) { 'private_api/foos.json' }
      it_behaves_like 'valid caching headers', cache_validation: false

      it "returns 200" do
        get url, {}, @env
        expect(response.status).to eq 200
      end

      it "sets pagination headers" do
        get url, {}, @env
        expect(response.headers['X-Page']).to eq '1'
        expect(response.headers['X-Limit']).to eq '25'
        expect(response.headers['X-Offset']).to eq '0'
        expect(response.headers['X-Total-Count']).to eq '0'
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
        expect(response.status).to eq 200
      end
    end
  end
end
