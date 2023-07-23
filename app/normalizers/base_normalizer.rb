class BaseNormalizer
  SEPARATOR = " - ".freeze

  def self.call(entity)
    new(entity).call
  end

  attr_reader :entity

  def initialize(entity)
    @entity = entity
  end

  def call
    NormalizedEntity.new(
      uid: uid,
      link: link,
      published_at: published_at,
      text: text.to_s,
      attachments: sanitized_attachments,
      comments: comments.compact_blank,
      validation_errors: validation_errors
    )
  end

  def link
    nil
  end

  # @return [DateTime] (guaranteed) post creation timestamp with a fallsback
  #   to the current time
  def published_at
    DateTime.now
  end

  def text
    nil
  end

  def attachments
    []
  end

  def comments
    []
  end

  def separator
    SEPARATOR
  end

  def validation_errors
    @validation_errors ||= base_validation_errors
  end

  private

  def base_validation_errors
    stale? ? ["stale"] : []
  end

  # @return [true, false] true if the entity is older than the import threshold
  def stale?
    feed_after && feed_after > published_at
  end

  def add_error(error)
    validation_errors << error
  end

  def sanitized_attachments
    attachments.compact_blank.map { UriSanitizer.new(_1).sanitize }
  end

  delegate :uid, :content, :feed, to: :entity
  delegate :options, :after, to: :feed, prefix: :feed
end
