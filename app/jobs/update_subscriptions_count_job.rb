class UpdateSubscriptionsCountJob < ApplicationJob
  queue_as :default

  def perform(feed_name)
    UpdateSubscriptionsCount.call(feed_name)
  end
end
