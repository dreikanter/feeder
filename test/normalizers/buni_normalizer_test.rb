require 'test_helper'
require_relative '../support/normalizer_test_helper'

class BuniNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    BuniNormalizer
  end

  def sample_data_file
    'feed_buni.xml'
  end

  def processor
    FeedjiraProcessor
  end

  def setup
    super

    sample_post = sample_file('post_buni.html')
    stub_request(:get, 'http://www.bunicomic.com/comic/buni-1315/')
      .to_return(status: 200, body: sample_post)

    webtoons_post = sample_file('post_buni_webtoons.html')
    stub_request(:get, 'http://www.bunicomic.com/2019/11/23/too-early/')
      .to_return(status: 200, body: webtoons_post)
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.all?(&:success?))
  end

  def test_uid
    expected = 'http://www.bunicomic.com/comic/buni-1315/'
    assert_equal(expected, ordinary_post_field(:uid))
  end

  def test_link
    expected = 'http://www.bunicomic.com/comic/buni-1315/'
    assert_equal(expected, ordinary_post_field(:link))
  end

  def test_text
    expected = 'De-Metamorphosis - http://www.bunicomic.com/comic/buni-1315/'
    assert_equal(expected, ordinary_post_field(:text))
  end

  def test_published_at
    expected = DateTime.parse('2019-11-25 06:00:09 UTC')
    assert_equal(expected, ordinary_post_field(:published_at))
  end

  EXPECTED_ATTACHMENTS = [
    'http://www.bunicomic.com/wp-content/uploads/2019/11/2019-11-25-Buni.jpg'
  ].freeze

  def test_attachments
    assert_equal(EXPECTED_ATTACHMENTS, ordinary_post_field(:attachments))
  end

  def test_comments
    assert_empty(ordinary_post_field(:comments))
  end

  WENTOONS_ATTACHMENTS = [
    'http://www.bunicomic.com/wp-content/' \
    'uploads/2019/11/ThumbHapiBuni260-530.jpg'
  ].freeze

  def test_webtoons_attachments
    assert_equal(WENTOONS_ATTACHMENTS, webtoons_post_field(:attachments))
  end

  WEBTOONS_COMMENTS = [
    'Check out today\'s comic on Webtoons: https://www.webtoons.com/' \
      'en/comedy/hapi-buni/ep-260/viewer?title_no=362&episode_no=260'
  ].freeze

  def test_webtoons_comments
    assert_equal(WEBTOONS_COMMENTS, webtoons_post_field(:comments))
  end

  def ordinary_post_field(field)
    normalized.first.value![field]
  end

  def webtoons_post_field(field)
    normalized.second.value![field]
  end
end
