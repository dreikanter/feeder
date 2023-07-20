require "test_helper"

class GithubBlogNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    GithubBlogNormalizer
  end

  def processor
    AtomProcessor
  end

  def sample_data_file
    "feed_github_blog.xml".freeze
  end

  def test_normalization
    assert(normalized.any?)
  end

  def test_all_attachment_urls_should_be_absolute
    attachments = normalized.map(&:attachments).flatten.compact

    attachments.each do |uri|
      assert(Addressable::URI.parse(uri).absolute?)
    end
  end
end
