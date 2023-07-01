class NormalizedEntity
  attr_reader :feed_id, :uid, :link, :published_at, :text, :attachments, :comments, :validation_errors

  def initialize(
    feed_id: nil,
    uid: nil,
    link: "",
    published_at: nil,
    text: "",
    attachments: [],
    comments: [],
    validation_errors: []
  )
    @feed_id = feed_id
    @uid = uid
    @link = link
    @published_at = published_at
    @text = text
    @attachments = attachments
    @comments = comments
    @validation_errors = validation_errors
  end

  def ==(other)
    as_json == other.as_json
  end

  def stale?
    feed_after.present? && (published_at_or_default < feed_after)
  end

  def find_or_create_post
    existing_post || create_post
  end

  def as_json
    {
      feed_id: feed_id,
      uid: uid,
      link: link,
      published_at: published_at,
      text: text,
      attachments: attachments,
      comments: comments,
      validation_errors: validation_errors
    }.as_json
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
      validation_errors: validation_errors
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
end
