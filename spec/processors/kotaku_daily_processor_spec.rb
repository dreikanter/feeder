require "rails_helper"

RSpec.describe KotakuDailyProcessor do
  subject(:processor) { described_class }

  let(:feed) { create(:feed, :kotaku_daily) }

  let(:content) { feed.loader_class.call(feed) }
  let(:entities) { processor.call(content, feed: feed) }
  let(:first_entity) { entities.first }
  let(:expected_post_urls) { JSON.parse(file_fixture("feeds/kotaku_daily/expected_post_urls.json").read) }
  let(:expected_comment_counts) { JSON.parse(file_fixture("feeds/kotaku_daily/expected_comment_counts.json").read) }

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
    expect(entities.first.uid).to eq("2023-06-16T00:00:00+00:00")
  end

  it "has content array" do
    expect(first_entity.content).to be_a(Array)
  end

  it "includes expected comments count" do
    expect(first_entity.content.pluck(:comments_count)).to eq(expected_comment_counts)
  end

  it "includes expected posts" do
    expect(first_entity.content.map { |item| item[:post].url }).to eq(expected_post_urls)
  end
end
