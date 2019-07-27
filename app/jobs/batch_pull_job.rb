class BatchPullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |exception|
    Error.dump(exception, class_name: self.class.name)
  end

  def perform
    started_at = Time.now.utc
    names = Service::FeedsList.names
    Feed.where(name: names).update_all(status: Enums::FeedStatus.active)
    Feed.where.not(name: names).update_all(status: Enums::FeedStatus.inactive)
    names.each { |feed_name| PullJob.perform_later(feed_name) }

    Service::CreateDataPoint.call(
      :batch,
      started_at: started_at,
      duration: Time.new.utc - started_at
    )
  end
end
