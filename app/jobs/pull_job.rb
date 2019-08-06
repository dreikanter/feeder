class PullJob < ApplicationJob
  before_perform :intro
  after_perform :outro

  def perform(feed)
    feed.update(refreshed_at: nil)
    Service::Pull.call(feed, on_error: errors_counter) do |post|
      PushJob.perform_later(post)
      count_post
    end
    feed.update(refreshed_at: started_at)
  end

  private

  attr_reader :posts_count, :errors_count, :started_at

  def intro
    @started_at = Time.now.utc
    @posts_count = 0
    @errors_count = 0
  end

  def outro
    Service::CreateDataPoint.call(
      :pull,
      feed_name: feed_name,
      posts_count: posts_count,
      errors_count: errors_count,
      duration: Time.new.utc - started_at,
      status: status,
      batch_id: batch_id
    )
  end

  def status
    return Enums::UpdateStatus.success if errors_count.zero?
    Enums::UpdateStatus.has_errors
  end

  def count_post
    @posts_count += 1
  end

  def errors_counter
    -> { @errors_count += 1 }
  end

  def feed_name
    arguments[0].name
  end

  def batch_id
    arguments[1].try(:id)
  end
end
