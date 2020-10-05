class PullJob < ApplicationJob
  queue_as :default

  def perform(feed)
    Import.call(feed)
  rescue StandardError => e
    Honeybadger.notify(e)
  end
end
