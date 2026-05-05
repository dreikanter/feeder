# Runs the loader → processor → normalizer pipeline for a single feed
# without writing any posts or calling the Freefeed API.
#
# Usage:
#   result = CheckFeed.call(feed)
#   result.ok?          # => true / false
#   result.entity_count # => Integer
#   result.error_message # => String or nil
class CheckFeed
  include Callee

  param :feed

  Result = Data.define(
    :feed_name,
    :loader,
    :processor,
    :normalizer,
    :entity_count,
    :validation_error_tally,
    :error_message
  )

  def call
    build_ok_result(normalize(load_entities))
  rescue StandardError => e
    build_error_result(e)
  end

  private

  def load_entities
    entities = process(load_content)
    limit = feed.import_limit_or_default
    limit.positive? ? entities.take(limit) : entities
  end

  def load_content
    feed.loader_class.new(feed).content
  end

  def process(content)
    feed.processor_class.new(content: content, feed: feed).process
  end

  def normalize(entities)
    normalizer_klass = feed.normalizer_class
    entities.filter_map do |entity|
      normalizer_klass.call(entity)
    rescue StandardError
      nil
    end
  end

  def build_ok_result(normalized)
    tally = normalized.flat_map(&:validation_errors).tally
    Result.new(
      feed_name: feed.name,
      loader: feed.loader,
      processor: feed.processor,
      normalizer: feed.normalizer,
      entity_count: normalized.size,
      validation_error_tally: tally,
      error_message: nil
    )
  end

  def build_error_result(error)
    Result.new(
      feed_name: feed.name,
      loader: feed.loader,
      processor: feed.processor,
      normalizer: feed.normalizer,
      entity_count: 0,
      validation_error_tally: {},
      error_message: error.message.truncate(200)
    )
  end
end
