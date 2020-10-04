class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    if post.ignored?
      logger.info('ignoring non-valid post')
      return
    end

    unless post.ready?
      logger.error("unexpected post status: #{post.status}")
      return
    end

    Push.call(post)
  rescue StandardError => e
    Honeybadger.notify(e)
  end
end
