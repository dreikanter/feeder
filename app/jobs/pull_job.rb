class PullJob < ApplicationJob
  queue_as :default

  def perform(feed)
    Import.call(feed)
  end
end
