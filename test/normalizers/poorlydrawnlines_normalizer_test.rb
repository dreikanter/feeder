require "test_helper"

class PoorlydrawnlinesNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    PoorlydrawnlinesNormalizer
  end

  def processor
    FeedjiraProcessor
  end

  def sample_data_file
    "feed_poorlydrawnlines.xml"
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: "http://www.poorlydrawnlines.com/comic/hello/",
      link: "http://www.poorlydrawnlines.com/comic/hello/",
      published_at: DateTime.parse("2018-10-22 16:03:51 UTC"),
      text: "Hello - http://www.poorlydrawnlines.com/comic/hello/",
      attachments: ["http://www.poorlydrawnlines.com/wp-content/uploads/2018/10/hello.png"],
      comments: [],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
