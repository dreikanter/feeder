class PullJob < ApplicationJob
  queue_as :default

  before_perform do |job|
    unless Const::Feeds::URLS.key?(job.arguments.first.to_sym)
      fail ArgumentError, "unknown feed name: #{job.arguments.first}"
    end
  end

  after_perform do |job|
    feed = Feed.find_by_name(job.arguments.first)
    Post.unpublished.where(feed: feed).each { |p| PushJob.perform_later(p) }
  end

  def perform(feed_name)
    url = Const::Feeds::URLS[feed_name.to_sym]
    re = RestClient.get(url)
    fail "error loading feed: #{url}" unless re.code == 200

    feed = Feed.find_or_create_by(name: feed_name)
    feed.touch(:refreshed_at)

    Service::Processor.for(feed_name).process(re.body).each do |entity|
      next if Post.where(feed: feed, link: entity['link']).exists?
      begin
        entity = Service::Postprocessor.for(feed_name).process(entity)
        Rails.logger.info 'creating new post'
        Post.create!(entity.merge(feed: feed))
      rescue => e
        Rails.logger.error "error processing feed entity: #{e.message}"
      end
    end
  end
end
