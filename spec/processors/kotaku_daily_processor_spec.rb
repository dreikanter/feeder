require "rails_helper"

RSpec.describe KotakuDailyProcessor do
  subject(:processor) { described_class }

  let(:feed) { create(:feed, :kotaku_daily) }

  let(:content) { feed.loader_class.call(feed) }
  let(:entities) { processor.call(content, feed: feed) }

  before do
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))

    stub_request(:get, feed.url)
      .to_return(body: file_fixture("feeds/kotaku/rss.xml").read)

    stub_request(:get, %r{^https://kotaku.com/.*-\d+$})
      .to_return(body: file_fixture("feeds/kotaku/post.html").read)
  end

  it "returns one entity" do
    expect(entities.count).to eq(1)
  end

  it "includes parsed post to each entity" do
    expect(entities.first.uid).to eq("https://kotaku.com/vinland-saga-season-2-thorfinn-netflix-crunchyroll-mapp-1850549053")
  end

  it "includes parsed post to each entity" do
    expect(entities.first.content[:post]).to be_a(Feedjira::Parser::RSSEntry)
  end

  it "includes comments count to each entity" do
    expect(entities.first.content[:comments_count]).to eq(237)
  end
end
