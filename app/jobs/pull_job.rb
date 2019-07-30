class PullJob < ApplicationJob
  queue_as :default

  def perform(feed_name, batch)
    started_at = Time.now.utc

    #
    # Fetch or create feed (it will raise an error if feed_name not exists)

    # TODO: Move to BatchJob or the rake task
    feed = Service::FeedBuilder.call(feed_name)

    #
    # Skip fresh feeds

    # TODO: Move to BatchJob
    unless feed.refresh?
      messages = [
        "skipping feed: #{feed_name}",
        "refresh interval: #{feed.refresh_interval}",
        "refreshed at: #{feed.refreshed_at}"
      ]
      logger.info("---> #{messages.join('; ')}")
      return
    end

    #
    # Intro

    feed.update(refreshed_at: nil)

    loader = Service::LoaderResolver.call(feed)
    logger.info("---> loading feed '#{feed_name}' with #{loader}")

    processor = Service::ProcessorResolver.call(feed)

    # TODO: Bypass feed to the processor
    # TODO: Move default_import_limit definition to constants
    limit = feed.import_limit ||
      Rails.application.credentials.default_import_limit.to_i

    logger.info("---> processor: #{processor}, import limit: #{limit}")

    normalizer = Service::NormalizerResolver.call(feed)
    logger.info("---> normalizer: #{normalizer}")

    posts_count = 0
    errors_count = 0

    #
    # Load content

    content = loader.call(feed)

    #
    # Process content
    entities = processor.call(content, limit: limit)

    #
    # Each entity

    entities.each do |uid, entity|
      logger.info("---> processing next entity #{'-' * 50}")

      #
      # Filter existing

      # Skip existing entities
      if Post.exists?(feed: feed, uid: uid)
        logger.debug('---> skipping existing post')
        next
      end

      #
      # Normalize

      normalized = normalizer.call(entity, feed.options)
      payload = normalized.payload

      #
      # Filter failed entities

      # Skip unprocessable entities
      if normalized.failure?
        logger.debug("---> entity rejected: #{payload}")
        next
      end

      #
      # Filter stale

      published_at = payload['published_at']
      after = feed.after

      # Skip stale entities
      unless !after || !published_at || (published_at > after)
        logger.debug('---> stale post; skipping')
        next
      end

      #
      # Create new post

      logger.info('---> creating new post')
      attrs = { uid: uid, feed_id: feed.id, status: Enums::PostStatus.ready }
      post = Post.create_with(payload).create!(attrs)

      # TODO: Move to outro
      feed.update(last_post_created_at: post.created_at)
      posts_count += 1
    rescue StandardError => e
      # TODO: Handle specific errors on each stage
      logger.error("---> error processing entity: #{e.message}")
      errors_count += 1
      Error.dump(
        e,
        class_name: self.class.name,
        feed_name: feed_name,
        hint: 'error processing entity'
      )
    end

    #
    # Outro

    feed.update(refreshed_at: started_at)

    # TODO: Move to the post creation block
    # TODO: Remove #publishing_queue_for scope
    Post.publishing_queue_for(feed).each { |p| PushJob.perform_later(p) }

    #
    # Outro

    status = errors_count.zero? ? :success : :has_errors

    Service::CreateDataPoint.call(
      :pull,
      feed_name: feed_name,
      posts_count: posts_count,
      errors_count: errors_count,
      duration: Time.new.utc - started_at,
      status: Enums::UpdateStatus.send(status),
      batch_id: batch.id
    )
  end

  def error_details
    {
      feed_name: arguments[0],
      hint: 'error processing feed'
    }.freeze
  end
end
