# Usage:
#
# - Create spec/fixtures/feeds/[FEED_NAME]/feed.xml
# - Create spec/fixtures/feeds/[FEED_NAME]/normalized.xml
# - Define `let(:feed)` configuration
#
RSpec.shared_examples "a normalizer" do
  subject(:normalizer) { described_class }

  # NOTE: Define actual feed in the spec
  let(:feed) { raise "undefined" }

  let(:feed_fixture) { "feeds/#{feed.name}/feed.xml" }
  let(:normalized_fixture) { "feeds/#{feed.name}/normalized.json" }

  let(:expected_posts_data) { JSON.parse(file_fixture(normalized_fixture).read) }
  let(:imported_post_ids) { PostsImporter.new(feed).import }

  let(:feed_fixture_path) { File.join(file_fixture_path, feed_fixture) }
  let(:normalized_fixture_path) { File.join(file_fixture_path, normalized_fixture) }

  let(:imported_posts_data) do
    Post.where(feed: feed, uid: imported_post_ids).as_json.map do |attributes|
      attributes.slice(*%w[
        uid
        state
        link
        published_at
        text
        attachments
        comments
        validation_errors
      ])
    end
  end

  before do
    Feed.delete_all
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))
    stub_feed_url if File.exist?(feed_fixture_path)
  end

  it { expect(feed.normalizer_class).to eq(described_class) }

  it "matches data snapshot" do
    unless File.exist?(normalized_fixture_path)
      File.write(normalized_fixture_path, JSON.pretty_generate(imported_posts_data))
      skip
    end

    expect(imported_posts_data).to eq(expected_posts_data)
  end

  def stub_feed_url
    stub_request(:get, feed.url)
      .to_return(body: file_fixture(feed_fixture).read)
      .times(1).then.to_raise("repeated loader call")
  end
end
