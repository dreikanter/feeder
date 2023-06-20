require "rails_helper"

RSpec.describe KotakuProcessor do
  subject(:processor) { described_class }

  let(:feed) { create(:feed, :kotaku) }
  let(:content) { KotakuLoader.call(feed) }
  let(:entities) { processor.call(content, feed: feed) }

  let(:expected_uids) do
    [
      "https://kotaku.com/vinland-saga-season-2-thorfinn-netflix-crunchyroll-mapp-1850549053",
      "https://kotaku.com/nintendo-switch-eshop-hidden-gems-sale-pride-queer-1850549209"
    ]
  end

  before do
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))

    stub_request(:get, feed.url)
      .to_return(body: file_fixture("feeds/kotaku/rss.xml").read)

    stub_request(:get, %r{^https://kotaku.com/.*-\d+$})
      .to_return(body: file_fixture("feeds/kotaku/post.html").read)
  end

  it "maintains expected uids order" do
    expect(entities.map(&:uid)).to eq(expected_uids)
  end

  it "returns rss entries as content" do
    expect(entities.map(&:content)).to all be_a(Feedjira::Parser::RSSEntry)
  end
end
