require 'test_helper'
require_relative '../support/normalizer_test_helper'

class InstagramNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    InstagramNormalizer
  end

  def processor
    InstagramProcessor
  end

  def sample_data_file
    'feed_instagram.json'
  end

  def sample_data
    @sample_data ||= JSON.parse(super)
  end

  def feed
    build(:feed, options: { instagram_user: 'dreikanter' })
  end

  def fetch_sample_data
    JSON.parse(super)
  end

  EXPECTED_ATTACHMENTS =
    Array.new(2).fill { |index| "https://example.com/#{index}" }.freeze

  def with_sample_node_script
    Tempfile.create(subject.name.demodulize) do |script_file|
      script_file.write("console.log(#{EXPECTED_ATTACHMENTS.to_json.dump})")
      script_file.close
      yield script_file.path
    end
  end

  def normalize_sample_data
    with_sample_node_script do |script_path|
      processed.map do |entity|
        subject.call(entity.uid, entity.content, feed, script_path: script_path)
      end
    end
  end

  def test_success
    normalized.each do |normalized_entity|
      assert(normalized_entity)
    end
  end

  def test_attachments
    normalized.each do |normalized_entity|
      assert(normalized_entity[:attachments].any?)
    end
  end

  def test_text
    normalized.each do |normalized_entity|
      refute(normalized_entity[:text].blank?)
    end
  end

  EXPECTED_SCHEME = 'https'.freeze
  EXPECTED_DOMAIN = 'instagram.com'.freeze

  def test_link
    normalized.each do |normalized_entity|
      link = normalized_entity[:link]
      assert(link)
      url = Addressable::URI.parse(link)
      assert_equal(EXPECTED_SCHEME, url.scheme)
      assert_equal(EXPECTED_DOMAIN, url.domain)
    end
  end

  def test_published_at
    normalized.each do |normalized_entity|
      assert(normalized_entity[:published_at].is_a?(DateTime))
    end
  end

  def test_multiple_attachments
    normalized.each do |normalized_entity|
      assert_equal(EXPECTED_ATTACHMENTS, normalized_entity[:attachments])
    end
  end
end
