require 'test_helper'
require_relative '../support/normalizer_test_helper'

class CommitstripNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    CommitstripNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_commitstrip.xml'.freeze
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.any?)
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.all?(&:success?))
  end

  # rubocop:disable Metric/LineLength
  FIRST_SAMPLE = {
    uid: 'https://www.commitstrip.com/2017/09/19/the-whole-teams-working-on-it/',
    link: 'https://www.commitstrip.com/2017/09/19/the-whole-teams-working-on-it/',
    published_at: DateTime.parse('2017-09-19 16:42:52 +0000'),
    text: 'The whole team’s working on it - https://www.commitstrip.com/2017/09/19/the-whole-teams-working-on-it/',
    attachments: ['https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-La-super-équipe-de-maintenance-650-finalenglish.jpg'],
    comments: [],
    validation_errors: []
  }.freeze
  # rubocop:enable Metric/LineLength

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
