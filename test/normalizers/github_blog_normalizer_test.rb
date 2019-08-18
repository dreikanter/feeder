require 'test_helper'
require_relative '../support/normalizer_test_helper'

class GithubBlogNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    GithubBlogNormalizer
  end

  def processor
    AtomProcessor
  end

  def sample_data_file
    'feed_github_blog.xml'.freeze
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.present?)
    assert_equal(processed.length, normalized.length)
  end

  def test_all_attachment_urls_should_be_absolute
    attachments = normalized.map { |entity| entity.value!['attachments'] }
    attachments.flatten.compact.each do |uri|
      assert(Addressable::URI.parse(uri).absolute?)
    end
  end
end
