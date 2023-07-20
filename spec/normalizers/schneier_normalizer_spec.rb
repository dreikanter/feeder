require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe SchneierNormalizer do
  subject(:subject_name) { described_class }

  # TBD
end

# class SchneierNormalizerTest < Minitest::Test
#   include NormalizerTestHelper

#   def subject
#     SchneierNormalizer
#   end

#   def processor
#     AtomProcessor
#   end

#   def sample_data_file
#     "feed_schneier.xml"
#   end

#   def expected
#     entity = JSON.parse(file_fixture("feeds/schneier/entity.json").read)
#     value = entity["published_at"]
#     entity["published_at"] = DateTime.parse(value) if value
#     NormalizedEntity.new(**entity.symbolize_keys.merge(feed_id: feed.id))
#   end

#   def test_normalized_sample
#     assert_equal(expected, normalized.first)
#   end
# end
