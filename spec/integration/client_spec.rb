require 'spec_helper'

describe SublimeVideoPrivateApi::Model do

  describe "collections" do
    let(:response_headers) { {
      'X-Page' => '1',
      'X-Per-Page' => '25',
      'X-Total-Count' => '2',
      'Etag' => 'foo'
    } }
    before do
      2.times { create(:foo) }
      stub_api_for(Foo) do |stub|
        stub.get("/private_api/foos") { |env| [200, response_headers, FooServer.all.to_json] }
      end
    end

    describe ".all" do
      it "returns all foos from API" do
        expect(Foo.all).to have(2).foos
      end

      it "returns paginated collection" do
        expect(Foo.all.total_count).to eq 2
      end
    end

    describe ".find_each" do
      it "iterates on pages" do
        expect(Foo).to receive(:all).with(page: 1, per: 2) { [1,2] }
        expect(Foo).to receive(:all).with(page: 2, per: 2) { [3] }

        Foo.find_each(batch_size: 2) {}
      end
    end

    describe ".count" do
      it "returns size from all" do
        expect(Foo.count).to eq 2
      end
    end
  end

  describe "get_raw" do
    let(:data) { ['foo'] }
    before do
      stub_api_for(Foo) do |stub|
        stub.get("/private_api/bar")   { |env| [200, {}, data.to_json] }
      end
    end

    it "returns custom data" do
      Foo.get_raw('/private_api/bar') do |parsed_data|
        parsed_data[:data] = data
      end
    end
  end

  describe "object" do
    let(:foo) { create(:foo) }
    before do
      @requests = 0
      stub_api_for(Foo) do |stub|
        stub.get("/private_api/foos/#{foo.id}") { |env| @requests += 1; [200, { 'Cache-Control' => 'max-age=400', 'Last-Modified' => Time.now }, foo.to_json] }
      end
    end
    subject { Foo.find(foo.id) }

    its(:id) { should eq foo.id }
    its(:created_at) { should be_kind_of(Time) }
    its(:updated_at) { should be_kind_of(Time) }

    it { should_not be_new }
    it { should be_persisted }

    it 'caches the result' do
      2.times { Foo.find(foo.id) }

      expect(@requests).to eq 1
    end
  end

  describe "inexistent object" do
    before do
      stub_api_for(Foo) do |stub|
        stub.get("/private_api/foos/42")   { |env| [404, {}, nil] }
      end
    end

    it { expect { Foo.find(42) }.to raise_error(Faraday::Error::ResourceNotFound)  }
  end

end
