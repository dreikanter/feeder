class PullJob < ApplicationJob
  queue_as :default

  def perform(feed_name)
    unless Const::Feeds::URLS.key?(feed_name)
      fail ArgumentError, "unknown feed name: #{feed_name}"
    end

    feed_url = Const::Feeds::URLS[feed_name]
    re = RestClient.get(feed_url)
    unless re.code == 200
      fail "error loading feed: #{feed_url}"
    end

    feed = Feed.find_or_create_by(name: feed_name)
    feed.touch(:refreshed_at)

    Service::Processor.for(feed_name).parse(re.body).each do |entity|
      next if Post.where(feed: feed, link: entity[:link]).exists?
      Rails.logger.info 'creating new post'
      Post.create_with(feed: feed).create!(entity)
    end
  end
end
