# Generates daily digest for the past date:
# - Receives RSS feed content from HttpLoader
# - Filters posts for the past date
# - Fetches comments count for each post
# - Order posts by comments count
# - Generates one Entity with the list of post references
class KotakuDailyProcessor < BaseProcessor
  protected

  def entities
    ordered_posts.map { |post| complemented_entity(post.url, post) }
  rescue StandardError => e
    Honeybadger.notify(e)
    []
  end

  private

  def complemented_entity(url, post)
    entity(url, { post: post, comments_count: cached_comments_count(url) })
  end

  def ordered_posts
    yesterday_posts.sort_by { |post| cached_comments_count(post.url) }.reverse
  end

  def yesterday_posts
    entries.filter { |post| post.published.yesterday? }
  end

  def entries
    @entries ||= Feedjira.parse(content).entries
  end

  def cached_comments_count(url)
    comment_counters[url] ||= KotakuCommentsCountLoader.new(url).comments_count
  end

  def comment_counters
    @comment_counters ||= {}
  end
end
