require 'test_helper'
require_relative '../support/normalizer_test_helper'

class TheAtlanticPhotosNormalizerTest < Minitest::Test
  include NormalizerTestHelper

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
    assert(normalized.each(&:success?))
  end

  # rubocop:disable Metric/LineLength
  FIRST_SAMPLE = {
    uid: 'http://feedproxy.google.com/~r/theatlantic/infocus/~3/5PMsxSsNGFk/',
    link: 'http://feedproxy.google.com/~r/theatlantic/infocus/~3/5PMsxSsNGFk/',
    published_at: DateTime.parse('2017-09-19 14:15:30 -0400'),
    text: 'Yellowstone National Park, now 145 years old, was the first national park established in the world. In 2016, the 2.2-million-acre park was visited by a record 4.2 million people, who came to experience the wilderness, explore countless geothermal features, witness the gorgeous vistas, and try to catch a glimpse of the resident wildlife. Gathered here are a handful of compelling photos from Yellowstone’s past, as... (continued) - https://www.theatlantic.com/photo/2017/09/a-photo-trip-through-yellowstone-national-park/540339/',
    attachments: ['https://cdn.theatlantic.com/assets/media/img/photo/2017/09/a-photo-trip-through-yellowstone-na/y01_WY09022006/main_1200.jpg?1505843933'],
    comments: ['The Lower Falls of the Yellowstone River, in Yellowstone National Park, photographed on September 2, 2006. (Stewart Tomlinson / U.S. Geological Survey)'],
    validation_errors: []
  }.freeze
  # rubocop:enable Metric/LineLength

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
