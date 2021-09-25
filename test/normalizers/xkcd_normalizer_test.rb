require 'test_helper'

class XkcdNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def setup
    super

    stub_request(:get, %r{//xkcd.com/\d+})
      .to_return(body: file_fixture('feeds/xkcd/post.html').read)
  end

  def subject
    XkcdNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_xkcd.xml'
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'http://xkcd.com/1732/',
      link: 'http://xkcd.com/1732/',
      published_at: DateTime.parse('2016-09-12 04:00:00 UTC'),
      text: 'Earth Temperature Timeline - http://xkcd.com/1732/',
      attachments: ['https://imgs.xkcd.com/comics/symbols_2x.png'],
      comments: ['[After setting your car on fire] Listen, your car\'s temperature has changed before.'],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
