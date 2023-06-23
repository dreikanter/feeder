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
end
