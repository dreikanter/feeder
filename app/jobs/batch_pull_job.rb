class BatchPullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |exception|
    Error.dump(exception, class_name: self.class.name)
  end

  def perform
    started_at = Time.now.utc

    Service::FeedsList.names.each do |name|
      PullJob.perform_now(name)
    end

    DataPoint.create_batch(
      started_at: started_at,
      duration: Time.new.utc - started_at
    )
  end
end
