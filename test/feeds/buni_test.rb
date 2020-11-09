require 'test_helper'

class BuniTest < Minitest::Test
  include FeedTestHelper

  def subject
    Pull.call(feed)
  end

  def feed_config
    {
      name: 'buni',
      processor: 'feedjira',
      normalizer: 'buni',
      url: 'bunicomic.com/feed/',
      import_limit: 4
    }
  end

  # TODO
  def sample_file(path)
    File.read(File.join(File.expand_path('../data', __dir__).freeze, path))
  end

  def setup
    super

    webtoons_post = sample_file('post_buni_webtoons.html')
    stub_request(:get, 'http://www.bunicomic.com/2019/11/23/too-early/')
      .to_return(status: 200, body: webtoons_post)

    sample_post = sample_file('post_buni.html')
    stub_request(:get, %r{^http://www.bunicomic.com})
      .to_return(status: 200, body: sample_post)
  end

  def source_fixture_path
    'feeds/buni.xml'
  end

  def expected_fixture_path
    'entities/buni.json'
  end
end
