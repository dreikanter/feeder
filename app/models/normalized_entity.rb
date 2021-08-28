class NormalizedEntity
  extend Dry::Initializer

  option :feed_id, optional: true
  option :uid, optional: true
  option :link, optional: true
  option :published_at, optional: true
  option :text, optional: true
  option :attachments, optional: true
  option :comments, optional: true
  option :validation_errors, optional: true, default: -> { [] }

  def ==(other)
    comparable_attributes(self) == comparable_attributes(other)
  end

  def diff(expected_entity)
    {}.tap do |result|
      COMPARABLE_ATTRIBUTES.map do |attribute|
        actual = send(attribute)
        expected = expected_entity.send(attribute)
        next if actual == expected
        result[attribute] = { expected: expected, actual: actual }
      end
    end
  end

  def stale?
    feed_after.present? && (published_at_or_default < feed_after)
  end

  def status
    validation_errors.none? ? PostStatus.ready : PostStatus.not_valid
  end

  def find_or_create_post
    existing_post || create_post
  end

  def as_json
    instance_values
  end

  private

  def existing_post
    Post.find_by(feed_id: feed_id, uid: uid)
  end

  def create_post
    Post.create!(
      feed_id: feed_id,
      uid: uid,
      link: link,
      published_at: published_at_or_default,
      text: text,
      attachments: attachments,
      comments: comments,
      validation_errors: validation_errors,
      status: status
    )
  end

  def published_at_or_default
    published_at ? published_at.to_datetime : DateTime.now
  end

  def feed_after
    feed.after
  end

  def feed
    @feed ||= Feed.find(feed_id)
  end

  COMPARABLE_ATTRIBUTES = %w[
    feed_id
    uid
    link
    published_at
    text
    attachments
    comments
    validation_errors
  ].freeze

  private_constant :COMPARABLE_ATTRIBUTES

  def comparable_attributes(subject)
    subject.instance_values.slice(*COMPARABLE_ATTRIBUTES)
  end
end
