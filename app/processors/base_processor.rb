class BaseProcessor
  attr_reader :content, :feed

  # @param :content [Object] arbitrary data object from the Loader
  # @param :feed [Feed] current feed reference
  def initialize(content:, feed:)
    @content = content
    @feed = feed
  end

  # Creates a Post record for each entity from the `content`. Skips already
  # imported entities.
  #
  # @return [Array<Post>] array of newly created draft posts
  # @raise [StandardError] raises exception if content is not processible
  def process
    raise AbstractMethodError
  end

  private

  # Finds or creates a Post record.
  #
  # @param :uid [String] unique post identifier. Can be a permalink URI.
  # @param :source_content [Object] entity content, arbitrary data object
  #   (should be JSON-friendly). Normalizer will use this data to populate
  #   Post attributes.
  # @param :published_at [DateTime, Time] optional publication timestamp.
  #   Default is `Time.current`.
  # @return [Post] finds or creates a draft Post record
  def build_post(uid:, source_content:, published_at:)
    Post.transaction do
      Post.create_with(
        state: "draft",
        source_content: source_content.as_json,
        published_at: published_at
      ).find_or_create_by!(feed: feed, uid: uid)
    end
  end
end
