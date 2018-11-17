# TODO: Replace with NormalizerResolver test

# require 'test_helper'

# class EntityNormalizerTest < Minitest::Test
#   SAMPLE_FEEDS = [
#     {
#       'name' => 'xkcd',
#       'url' => 'http://xkcd.com/rss.xml',
#       'processor' => 'rss'
#     },
#     {
#       'name' => 'dilbert',
#       'url' => 'http://dilbert.com/feed',
#       'processor' => 'atom'
#     },
#     {
#       'name' => 'processor-name-example',
#       'url' => 'http://example.com/feed',
#       'processor' => 'rss'
#     },
#     {
#       'name' => 'livejournal-example',
#       'url' => 'http://example.livejournal.com/data/rss',
#       'processor' => 'rss',
#       'normalizer' => 'livejournal'
#     },
#     {
#       'name' => 'medium-example',
#       'url' => 'https://medium.com/feed/@example',
#       'processor' => 'rss',
#       'normalizer' => 'medium'
#     }
#   ].freeze

#   SAMPLE_NO_MATCH = {
#     'name' => 'null-example',
#     'url' => 'http://example.com/feed'
#   }.freeze

#   EXPECTED_NORMALIZERS = {
#     'xkcd' => Normalizers::XkcdNormalizer,
#     'dilbert' => Normalizers::DilbertNormalizer,
#     'processor-name-example' => Normalizers::RssNormalizer,
#     'livejournal-example' => Normalizers::LivejournalNormalizer,
#     'medium-example' => Normalizers::MediumNormalizer
#   }.freeze

#   def test_for
#     SAMPLE_FEEDS.each do |attrs|
#       name = attrs['name']
#       feed = Feed.create_with(attrs).find_or_create_by(name: name)
#       result = Service::EntityNormalizer.for(feed)
#       assert_equal(result, EXPECTED_NORMALIZERS[name])
#     end
#   end

#   def test_no_matches
#     assert_raises do
#       Service::EntityNormalizer.for(SAMPLE_NO_MATCH)
#     end
#   end
# end
