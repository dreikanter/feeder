class BaseNormalizer
  include Callee
  include Dry::Monads[:result]

  param :uid
  param :entity
  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    logger.info("normalizing entity [#{uid}]")
    valid? ? Success(payload) : Failure(validation_errors)
  rescue StandardError => e
    logger.error(e)
    Failure(e)
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
      text: text,
      attachments: sanitized_attachments,
      comments: comments.reject(&:blank?)
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
