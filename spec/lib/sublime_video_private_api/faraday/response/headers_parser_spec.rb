require 'fast_spec_helper'

require 'sublime_video_private_api/faraday/response/headers_parser'

describe SublimeVideoPrivateApi::Faraday::Response::HeadersParser do
  let(:parser) { described_class.new }

  it "sets pagination metadata from headers" do
    env = {
      body: Hash.new { |h,k| h[k] = {} },
      response_headers: {
        'X-Page' => 1,
        'X-Limit' => 10,
        'X-Offset' => 1,
        'X-Total-Count' => 12
      }
    }
    parser.on_complete(env)
    env[:body].should eq(metadata: {
      page: 1,
      limit: 10,
      offset: 1,
      total_count: 12
    })
  end

end
