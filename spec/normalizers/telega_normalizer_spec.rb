require "test_helper"

class TelegaNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    TelegaNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    "feed_agavr_today.xml".freeze
  end

  def first_sample
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: "http://tele.ga/agavr_today/126.html",
      link: "http://tele.ga/agavr_today/126.html",
      published_at: DateTime.parse("2017-09-07 14:51:45 +0000"),
      text: "Находясь в настоящий момент... - http://tele.ga/agavr_today/126.html",
      attachments: [],
      comments: [],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(first_sample, normalized.first)
  end
end
