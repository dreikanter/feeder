require 'test_helper'
require_relative '../support/normalizer_test_helper'

class TheAtlanticPhotosNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def setup
    super

    stub_request(:get, /feedproxy.google.com/)
      .to_return(status: 200, body: '')
  end

  def subject
    TheAtlanticPhotosNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_the_atlantic_photos.xml'.freeze
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.any?)
  end

  def test_normalization
    assert(normalized.any?)
  end

  def test_uid
    assert_equal(
      'http://feedproxy.google.com/~r/theatlantic/infocus/~3/5PMsxSsNGFk/',
      normalized.first[:uid]
    )
  end

  def test_link
    assert_equal(
      'http://feedproxy.google.com/~r/theatlantic/infocus/~3/5PMsxSsNGFk/',
      normalized.first[:link]
    )
  end

  def test_published_at
    assert_equal(
      DateTime.parse('2017-09-19 14:15:30 -0400'),
      normalized.first[:published_at]
    )
  end

  # rubocop:disable Layout/LineLength
  EXPECTED_TEXT = 'Yellowstone National Park, now 145 years old, was the first national park established in the world. In 2016, the 2.2-million-acre park was visited by a record 4.2 million people, who came to experience the wilderness, explore countless geothermal features, witness the gorgeous vistas, and try to catch a glimpse of the resident wildlife. Gathered here are a handful of compelling photos from Yellowstone’s past, as... (continued) - http://feedproxy.google.com/~r/theatlantic/infocus/~3/5PMsxSsNGFk/'.freeze
  # rubocop:enable Layout/LineLength

  def test_text
    assert_equal(EXPECTED_TEXT, normalized.first[:text])
  end

  EXPECTED_ATTACHMENTS = [
    'https://cdn.theatlantic.com/assets/media/img/photo/2017/09/a-photo-trip-through-yellowstone-na/y01_WY09022006/main_1200.jpg?1505843933'
  ].freeze

  def test_attachments
    assert_equal(EXPECTED_ATTACHMENTS, normalized.first[:attachments])
  end

  # rubocop:disable Layout/LineLength
  EXPECTED_COMMENTS = [
    'The Lower Falls of the Yellowstone River, in Yellowstone National Park, photographed on September 2, 2006. (Stewart Tomlinson / U.S. Geological Survey)'
  ].freeze
  # rubocop:enable Layout/LineLength

  def test_comments
    assert_equal(EXPECTED_COMMENTS, normalized.first[:comments])
  end

  def test_validation_errors
    assert_empty(normalized.first[:validation_errors])
  end
end
