require 'spec_helper'

describe SublimeVideoPrivateApi::Model do

  describe "collections" do
    let(:response_headers) { {
      'X-Page' => '1',
      'X-Per-Page' => '25',
      'X-Total-Count' => '2',
    } }
    before {
      2.times { create(:foo) }
      stub_api_for(Foo) do |stub|
        stub.get("/private_api/foos")   { |env| [200, response_headers, FooServer.all.to_json] }
      end
    }

    describe ".all" do
      it "returns all foos from API" do
        Foo.all.should have(2).foos
      end

      it "returns paginated collection" do
        Foo.all.total_count.should eq 2
      end
    end

    describe ".find_each" do
      it "iterates on pages" do
        Foo.should_receive(:all).with(page: 1, per: 2) { [1,2] }
        Foo.should_receive(:all).with(page: 2, per: 2) { [3] }

        Foo.find_each(batch_size: 2) {}
      end
    end

    describe ".count" do
      it "returns size from all" do
        Foo.count.should eq 2
      end
    end
  end

  describe "object" do
    let(:foo) { create(:foo) }
    before {
      stub_api_for(Foo) do |stub|
        stub.get("/private_api/foos/#{foo.id}")   { |env| [200, {}, foo.to_json] }
      end
    }
    subject { Foo.find(foo.id) }

    its(:id) { should eq foo.id }
    its(:created_at) { should be_kind_of(Time) }
    its(:updated_at) { should be_kind_of(Time) }

    it { should_not be_new }
    it { should be_persisted }
  end

end
