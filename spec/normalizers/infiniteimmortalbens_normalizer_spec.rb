require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe InfiniteimmortalbensNormalizer do
  subject(:subject_name) { described_class }

  # TBD
end

# class InfiniteimmortalbensNormalizerTest < Minitest::Test
#   include NormalizerTestHelper

#   def subject
#     InfiniteimmortalbensNormalizer
#   end

#   def processor
#     RssProcessor
#   end

#   def sample_data_file
#     "feed_infiniteimmortalbens.xml".freeze
#   end

#   def test_text
#     normalized.each do |entity|
#       assert_not(entity.text.empty?)
#     end
#   end

#   def test_comments
#     normalized.each do |entity|
#       assert(entity.comments.empty?)
#     end
#   end

#   def test_valid_link
#     normalized.each do |entity|
#       Addressable::URI.parse(entity.link)
#     end
#   end

#   def test_published_at
#     normalized.each do |entity|
#       assert(entity.published_at.is_a?(DateTime))
#     end
#   end

#   def test_attachments
#     normalized.each do |entity|
#       result = entity.attachments
#       assert(result.is_a?(Array))
#       assert(result.any?)
#     end
#   end
# end
