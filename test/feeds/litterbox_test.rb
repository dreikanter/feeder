require 'test_helper'

class LitterboxTest < Minitest::Test
  include FeedTestHelper

  def setup
    super

    stub_request(:get, 'https://www.litterboxcomics.com/claw-machine/')
      .to_return(body: file_fixture('feeds/litterbox/post.html').read)

    stub_request(:get, 'https://www.litterboxcomics.com/claw-machine-bonus/')
      .to_return(body: file_fixture('feeds/litterbox/bonus_panel.html').read)
  end

  def feed_config
    {
      name: 'litterbox',
      processor: 'wordpress',
      normalizer: 'litterbox',
      url: 'https://www.litterboxcomics.com/feed/'
    }
  end

  def source_fixture_path
    'feeds/litterbox/feed.xml'
  end

  def expected_fixture_path
    'feeds/litterbox/entry.json'
  end
end
