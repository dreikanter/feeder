require 'test_helper'

class FeedsListTest < Minitest::Test
  def subject
    FeedsList
  end

  SAMPLE_CONFIG_PATH =
    File.expand_path('../data/feeds.yml', __dir__).freeze

  NON_EXISTING_CONFIG_PATH =
    File.expand_path('../data/feeds_not_existing.yml', __dir__).freeze

  NOT_VALID_CONFIG_PATH =
    File.expand_path('../data/feeds_not_valid.yml', __dir__).freeze

  NOT_ARRAY_CONFIG_PATH =
    File.expand_path('../data/feeds_not_array.yml', __dir__).freeze

  def result
    subject.call(path: SAMPLE_CONFIG_PATH)
  end

  def expected
    YAML.load_file(SAMPLE_CONFIG_PATH)
      .map(&:symbolize_keys)
      .map(&FeedSanitizer)
  end

  def setup
    DataPoint.for(:config).delete_all
  end

  def test_names_match_config
    actual_names = result.map(&:name).sort
    expected_names = expected.map { |conf| conf[:name] }.sort
    assert(expected_names, actual_names)
  end

  def test_attributes_match_config
    feeds = result.map { |feed| [feed.name, feed] }.to_h
    expected.each do |config|
      feed = feeds[config[:name]]
      config.each_pair do |key, value|
        actual = feed.send(key)
        value && assert_equal(value, actual) || assert_nil(actual)
      end
    end
  end

  def test_non_existing_config
    refute(File.exist?(NON_EXISTING_CONFIG_PATH))
    assert_raises(Errno::ENOENT) do
      subject.call(path: NON_EXISTING_CONFIG_PATH)
    end
  end

  def test_malformed_config
    assert_raises(Psych::SyntaxError) do
      subject.call(path: NOT_VALID_CONFIG_PATH)
    end
  end

  def test_not_array_config
    assert_raises(RuntimeError) do
      subject.call(path: NOT_ARRAY_CONFIG_PATH)
    end
  end
end
