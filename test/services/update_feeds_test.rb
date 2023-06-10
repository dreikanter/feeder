require 'test_helper'

class UpdateFeedsTest < Minitest::Test
  def subject
    UpdateFeeds
  end

  SAMPLE_CONFIG_PATH =
    File.expand_path('../data/feeds.yml', __dir__).freeze

  ALT_SAMPLE_CONFIG_PATH =
    File.expand_path('../data/feeds_alt.yml', __dir__).freeze

  NON_EXISTING_CONFIG_PATH =
    File.expand_path('../data/feeds_not_existing.yml', __dir__).freeze

  NOT_VALID_CONFIG_PATH =
    File.expand_path('../data/feeds_not_valid.yml', __dir__).freeze

  NOT_ARRAY_CONFIG_PATH =
    File.expand_path('../data/feeds_not_array.yml', __dir__).freeze

  def setup
    super

    # TODO: Fix transactional tests
    Feed.delete_all
  end

  def expected
    @expected ||= YAML.load_file(SAMPLE_CONFIG_PATH).map { |feed| FeedSanitizer.call(**feed.symbolize_keys) }
  end

  def test_names_match_config
    subject.call(path: SAMPLE_CONFIG_PATH)
    actual_names = Feed.pluck(:name).to_set
    expected_names = expected.pluck(:name).to_set
    assert(expected_names, actual_names)
  end

  def test_update_inactive_feeds_status
    feed = Feed.create!(name: SecureRandom.hex, status: FeedStatus.active)
    subject.call(path: SAMPLE_CONFIG_PATH)
    feed.reload
    assert(feed.inactive?)
  end

  def test_active_feeds_status
    subject.call(path: SAMPLE_CONFIG_PATH)
    Feed.update_all(status: FeedStatus.inactive)
    subject.call(path: SAMPLE_CONFIG_PATH)
    assert(Feed.inactive.none?)
    assert(Feed.active.count, Feed.count)
  end

  def test_attributes_match_config
    subject.call(path: SAMPLE_CONFIG_PATH)
    expected.each do |expected_feed|
      feed = Feed.find_by(name: expected_feed[:name])
      assert(feed)
      expected_feed.each do |attribute_name, expected_value|
        actual_value = feed.send(attribute_name)
        if expected_value.nil?
          assert_nil(actual_value)
        else
          assert_equal(expected_value, actual_value)
        end
      end
    end
  end

  def test_config_override_existind_records
    subject.call(path: ALT_SAMPLE_CONFIG_PATH)
    subject.call(path: SAMPLE_CONFIG_PATH)
    expected.each do |expected_feed|
      feed = Feed.find_by(name: expected_feed[:name])
      assert(feed)
      expected_feed.each do |attribute_name, expected_value|
        actual_value = feed.send(attribute_name)
        if expected_value.nil?
          assert_nil(actual_value)
        else
          assert_equal(expected_value, actual_value)
        end
      end
    end
  end

  def test_non_existing_config
    assert_not(File.exist?(NON_EXISTING_CONFIG_PATH))
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
