require "rails_helper"
require "support/shared_examples_a_normalizer"

# class LitterboxSlidesTest < Minitest::Test
#   include FeedTestHelper

#   def subject
#     Pull.call(feed).first
#   end

#   def setup
#     super

#     stub_request(:get, "https://www.litterboxcomics.com/worlds-collide/")
#       .to_return(body: file_fixture("feeds/litterbox/post_slides.html").read)

#     stub_request(:get, "https://www.litterboxcomics.com/worlds-collide-bonus/")
#       .to_return(body: file_fixture("feeds/litterbox/bonus_panel_slides.html").read)
#   end

#   def feed_config
#     {
#       name: "litterbox",
#       loader: "http",
#       processor: "wordpress",
#       normalizer: "litterbox",
#       url: "https://www.litterboxcomics.com/feed/"
#     }
#   end

#   def source_fixture_path
#     "feeds/litterbox/feed_slides.xml"
#   end

#   def expected_fixture_path
#     "feeds/litterbox/entry_slides.json"
#   end
# end
