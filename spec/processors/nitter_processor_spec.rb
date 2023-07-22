require "rails_helper"

RSpec.describe NitterProcessor do
  subject(:processor) { described_class }

  let(:content) { file_fixture("feeds/nitter/rss.xml").read }
  let(:entities) { processor.new(content: content, feed: feed).entities }

  let(:feed) do
    build(
      :feed,
      loader: "nitter",
      processor: "nitter",
      normalizer: "nitter",
      import_limit: 0,
      options: {
        "twitter_user" => "username",
        "only_with_attachments" => true,
        "ignore_retweets" => true
      }
    )
  end

  let(:expected_uids) do
    [
      "https://twitter.com/extrafabulous/status/1664634629456887813#m",
      "https://twitter.com/extrafabulous/status/1664067666162728960#m",
      "https://twitter.com/PervisTime/status/1664280381473058817#m"
    ]
  end

  it "uses Twitter URL for uids" do
    expect(entities.map(&:uid)).to eq(expected_uids)
  end
end
