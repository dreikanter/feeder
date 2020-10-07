class BaseNormalizer
  include Callee

  param :uid
  param :entity
  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  # TODO: Introduce NormalizedEntity class to replace payload hash
  def call
    logger.info("---> normalizing entity [#{uid}] with [#{self.class.name}]")
    payload
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

  SEPARATOR = ' - '.freeze

  def separator
    SEPARATOR
  end

  def valid?
    validation_errors.blank?
  end

  def validation_errors
    []
  end

  def options
    feed.try(:options) || {}
  end

  def payload
    {
      uid: uid,
      link: link,
      published_at: published_at,
      text: text || '',
      attachments: sanitized_attachments,
      comments: comments.reject(&:blank?),
      validation_errors: validation_errors
    }.freeze
  end

  DEFAULT_SCHEME = 'https'.freeze

  def sanitized_attachments
    attachments.reject(&:blank?).map do |url|
      value = Addressable::URI.parse(url)
      value.scheme ||= DEFAULT_SCHEME
      value.to_s
    end
  end
end
