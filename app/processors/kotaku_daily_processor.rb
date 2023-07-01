# Generates daily digest for the past date:
# - Receives RSS feed content from HttpLoader
# - Filters posts for the past date
# - Fetches comments count for each post
# - Order posts by comments count
# - Generates one FeedEntity
# - Assigns FeedEntity uid with a serialized publication date
# - Assigns FeedEntity content with the ordered posts array
class KotakuDailyProcessor < BaseProcessor
  protected

  def entities
    [build_entity(yesterday.rfc3339, ordered_posts)]
  rescue StandardError => e
    Honeybadger.notify(e)
    []
  end

  private

  def ordered_posts
    complemented_posts.sort_by { |post| post[:comments_count] }.reverse
  end

  def complemented_posts
    yesterday_posts.map { |post| {post: post, comments_count: comments_count(post.url)} }
  end

  def yesterday_posts
    entries.filter { |post| post.published.yesterday? }
  end

  def entries
    Feedjira.parse(content).entries
  end

  def comments_count(url)
    comment_counters[url] ||= KotakuCommentsCountLoader.new(url).comments_count
  end

  def comment_counters
    @comment_counters ||= {}
  end

  def yesterday
    @yesterday ||= Date.yesterday
  end
end
