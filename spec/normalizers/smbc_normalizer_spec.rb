require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe SmbcNormalizer do
  subject(:subject_name) { described_class }

  # TBD
end

# class SmbcNormalizerTest < Minitest::Test
#   include NormalizerTestHelper

#   def subject
#     SmbcNormalizer
#   end

#   def setup
#     super

#     stub_request(:get, "https://www.smbc-comics.com/comic/back")
#       .to_return(body: sample_post)

#     stub_request(:get, "https://www.smbc-comics.com/comic/kill")
#       .to_return(body: sample_post)
#   end

#   def processor
#     RssProcessor
#   end

#   def sample_data_file
#     "feed_smbc.xml"
#   end

#   def sample_post_file
#     "post_smbc.html"
#   end

#   def expected
#     NormalizedEntity.new(
#       feed_id: feed.id,
#       uid: "https://www.smbc-comics.com/comic/back",
#       link: "https://www.smbc-comics.com/comic/back",
#       text: "Back - https://www.smbc-comics.com/comic/back",
#       published_at: DateTime.parse("2019-08-16 08:40:18 -0400"),
#       attachments: [
#         "https://www.smbc-comics.com/comics/1565959235-20190816.png",
#         "https://www.smbc-comics.com/comics/156372243220190721after.png"
#       ],
#       comments: ["I mean, statistically, shouldn't this be the most common outcome?"],
#       validation_errors: []
#     )
#   end

#   def test_normalization
#     assert_equal(expected, normalized.first)
#   end
# end
