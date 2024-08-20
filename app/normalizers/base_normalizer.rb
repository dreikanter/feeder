class BaseNormalizer
  attr_reader :feed_entity

  # Accept feed, pass entity separately, reuser feed.normalizer_instance
  # -> Accept entity, use disposable instances, keep data flow simple
  #
  # @param [FeedEntity]
  def initialize(feed_entity)
    @feed_entity = feed_entity
  end

  # @return [Post] an unpersisted Post instance hydrated with normalized entity data
  def normalize
    Post.new(
      feed: feed,
      uid: uid,
      link: link,
      published_at: published_at,
      text: text,
      attachments: attachments,
      comments: comments,
      validation_errors: validation_errors
    )
  end

  # Override required.
  # @return [String] current entity identifier, unique in the feed scope
  def uid
    raise AbstractMethodError
  end

  # Override required.
  # @return [String]
  def link
    raise AbstractMethodError
  end

  # Override required.
  # @return [DateTime] original publication timestamp
  def published_at
    raise AbstractMethodError
  end

  # Override required.
  # @return [String] entity content
  def text
    raise AbstractMethodError
  end

  # Override is optional.
  # @return [Array<String>] array of attachment file URLs (optional)
  def attachments
    []
  end

  # Override is optional.
  # @return [Array<String>] array of comments (optional)
  def comments
    []
  end

  # Override is optional.
  # @return [Array<String>] array of error code values in case the entity
  #   can not be reposted; empty array means the normalized entity content
  #   is ready for publication
  def validation_errors
    []
  end

  # @return [true, false] true if the entity is not suitable for publication
  def validation_errors?
    validation_errors.any?
  end

  private

  delegate :feed, to: :feed_entity, private: true
end
