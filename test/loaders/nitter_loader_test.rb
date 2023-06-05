require "test_helper"

class NitterLoaderTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { NitterLoader }

  let(:feed) do
    build(
      :feed,
      url: nil,
      name: "sample_twitter_feed",
      options: { "twitter_user" => "username" }
    )
  end

  let(:body) { "CONTENT BODY" }
  let(:nitter_url) { "#{NitterLoader::DEFAULT_NITTER_URL}/username/rss" }

  def test_fetches_nitter_url
    stub_request(:get, nitter_url).to_return(body: body)
    result = subject.call(feed)
    assert_equal body, result
  end

  def test_pass_http_client_error
    stub_request(:get, nitter_url).to_raise(StandardError)
    assert_raises(StandardError) { subject.call(feed) }
  end

  def test_require_twitter_user_option
    feed.options = {}
    assert_raises(KeyError) { subject.call(feed) }
  end
end
