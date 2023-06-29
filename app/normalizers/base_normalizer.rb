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
      feed_id: feed.id,
      uid: uid,
      link: link,
      published_at: published_at,
      text: text.to_s,
      attachments: sanitized_attachments,
      comments: comments.compact_blank,
      validation_errors: validation_errors
    )
  end

  protected

  def link
    nil
  end

  def published_at
    nil
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
    @validation_errors ||= []
  end

  def add_error(error)
    validation_errors << error
  end

  private

  delegate :uid, :content, :feed, to: :entity
  delegate :options, to: :feed

  def sanitized_attachments
    attachments.compact_blank.map { UriSanitizer.new(_1).sanitize }
  end
end
