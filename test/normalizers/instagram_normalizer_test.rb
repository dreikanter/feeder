require 'test_helper'
require_relative '../support/normalizer_test_helper'

module Normalizers
  class InstagramNormalizerTest < Minitest::Test
    include NormalizerTestHelper

    def subject
      Normalizers::InstagramNormalizer
    end

    def processor
      Processors::InstagramProcessor
    end

    def sample_data_file
      'feed_instagram.json'
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
          subject.call(entity[0], entity[1], feed, script_path: script_path)
        end
      end
    end

    def test_success
      normalized.each do |normalized_entity|
        assert(normalized_entity.success?)
      end
    end

    def test_attachments
      normalized.each do |normalized_entity|
        value = normalized_entity.value!
        assert(value['attachments'].any?)
      end
    end

    def test_text
      normalized.each do |normalized_entity|
        value = normalized_entity.value!
        refute(value['text'].blank?)
      end
    end

    EXPECTED_SCHEME = 'https'.freeze
    EXPECTED_DOMAIN = 'instagram.com'.freeze

    def test_link
      normalized.each do |normalized_entity|
        link = normalized_entity.value!['link']
        assert(link)
        url = Addressable::URI.parse(link)
        assert_equal(EXPECTED_SCHEME, url.scheme)
        assert_equal(EXPECTED_DOMAIN, url.domain)
      end
    end

    def test_published_at
      normalized.each do |normalized_entity|
        value = normalized_entity.value!
        assert(value['published_at'].is_a?(DateTime))
      end
    end

    def test_multiple_attachments
      normalized.each do |normalized_entity|
        value = normalized_entity.value!
        assert_equal(EXPECTED_ATTACHMENTS, value['attachments'])
      end
    end
  end
end
