require "test_helper"

class BuniTest < Minitest::Test
  include FeedTestHelper

  # Compare the whole feed instead of the first entiry
  def subject
    Pull.call(feed)
  end

  def feed_config
    {
      name: "buni",
      processor: "feedjira",
      normalizer: "buni",
      url: "http://bunicomic.com/feed/",
      import_limit: 4
    }
  end

  def setup
    super

    webtoons_post = file_fixture("feeds/buni/post_webtoons.html").read
    stub_request(:get, "http://www.bunicomic.com/2019/11/23/too-early/")
      .to_return(status: 200, body: webtoons_post)

    sample_post = file_fixture("feeds/buni/post.html").read
    stub_request(:get, %r{^http://www.bunicomic.com})
      .to_return(status: 200, body: sample_post)
  end

  def source_fixture_path
    "feeds/buni/feed.xml"
  end

  def expected_fixture_path
    "feeds/buni/entity.json"
  end
end
