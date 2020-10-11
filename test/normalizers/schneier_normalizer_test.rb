require 'test_helper'
require_relative '../support/normalizer_test_helper'

class SchneierNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    SchneierNormalizer
  end

  def processor
    AtomProcessor
  end

  def sample_data_file
    'feed_schneier.xml'
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'https://www.schneier.com/blog/archives/2019/08/google_finds_20.html',
      link: 'https://www.schneier.com/blog/archives/2019/08/google_finds_20.html',
      published_at: DateTime.parse('2019-08-21 11:46:38 UTC'),
      text: 'Google Finds 20-Year-Old Microsoft Windows Vulnerability - https://www.schneier.com/blog/archives/2019/08/google_finds_20.html',
      attachments: [],
      comments: ["There's no indication that this vulnerability was ever used in the wild, but the code it was discovered in -- Microsoft's Text Services Framework -- has been around since Windows XP."],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
