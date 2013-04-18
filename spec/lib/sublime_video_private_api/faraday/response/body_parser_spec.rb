require 'fast_spec_helper'

require 'sublime_video_private_api/faraday/response/body_parser'

describe SublimeVideoPrivateApi::Faraday::Response::BodyParser do
  let(:parser) { described_class.new }

  it "works with empty response" do
    parser.on_complete body: ''
  end

end
