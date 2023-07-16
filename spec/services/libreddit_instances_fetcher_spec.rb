require "rails_helper"

RSpec.describe LibredditInstancesFetcher do
  subject(:result) { described_class.new.call }

  let(:expected_result) do
    %w[
      https://safereddit.com
      https://libreddit.kavin.rocks
    ]
  end

  before do
    stub_request(:get, "https://raw.githubusercontent.com/libreddit/libreddit-instances/master/instances.json")
      .to_return(body: file_fixture("libreddit_instances.json").read)
  end

  it { expect(result).to eq(expected_result) }
end
