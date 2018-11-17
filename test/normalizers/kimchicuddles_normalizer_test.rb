require_relative 'normalizer_test'

class KimchicuddlesNormalizerTest < NormalizerTest
  def sample_data_file
    'feed_kimchicuddles.xml'
  end

  def processor
    Processors::FeedjiraProcessor
  end

  def normalizer
    Normalizers::KimchicuddlesNormalizer
  end

  def test_sample_data_file_exists
    assert File.exist?(sample_data_path)
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.present?)
    assert_equal(processed.length, normalized.length)
  end

  FIRST_SAMPLE = {
    'link' => 'http://kimchicuddles.com/post/178513799060',
    'published_at' => Time.parse('2018-09-27 15:53:34 UTC'),
    'text' => 'http://kimchicuddles.com/post/178513799060',
    'attachments' => ['https://66.media.tumblr.com/45381225846ed0dde118340a6aeb4329/tumblr_pfq1hahDTV1spe4pno1_500.jpg'],
    "comments" => ["Who are some people you’re grateful for right now?\nIf you appreciate my work, check out my Patreon: https://www.patreon.com/kimchicuddles"]
  }.freeze

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.payload)
  end
end
