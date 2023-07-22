require "rails_helper"

RSpec.describe KotakuLoader do
  subject(:load_content) { described_class.new(feed).content }

  let(:feed) { create(:feed, :kotaku) }

  let(:expected_timestamps_order) do
    [
      "2023-06-16 21:00:00 UTC",
      "2023-06-16 21:15:00 UTC",
      "2023-06-16 21:40:00 UTC",
      "2023-06-16 22:20:00 UTC",
      "2023-06-16 22:30:00 UTC",
      "2023-06-16 23:35:00 UTC"
    ].map { DateTime.parse(_1) }
  end

  before do
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))

    stub_request(:get, feed.url)
      .to_return(body: file_fixture("feeds/kotaku/rss.xml").read)

    stub_request(:get, %r{^https://kotaku.com/.*-\d+$})
      .to_return(body: file_fixture("feeds/kotaku/post.html").read)
  end

  it "resolves" do
    expect(feed.loader_class).to eq(described_class)
  end

  it "returns entries" do
    expect(load_content).to all be_a(Feedjira::Parser::RSSEntry)
  end

  it "maintains expected order" do
    expect(load_content.map(&:published)).to eq(expected_timestamps_order)
  end
end
