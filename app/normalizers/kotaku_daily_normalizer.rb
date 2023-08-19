class KotakuDailyNormalizer < BaseNormalizer
  DEFAULT_MAX_POSTS_NUMBER = 10

  def text
    "Kotaku top publications for #{digest_date.strftime("%d %b %Y")} - #{link}"
  end

  def link
    "https://kotaku.com/latest?startTime=#{digest_unixtime}"
  end

  def published_at
    digest_date
  end

  def attachments
    [first_post_image].compact_blank
  end

  def comments
    content.first(max_posts_number).map do |item|
      post = item.fetch(:post)
      build_comment(post.title.strip, post.author.strip, post.url.strip, item.fetch(:comments_count))
    end
  end

  private

  def first_post_image
    content.first&.fetch(:post)&.image
  end

  # :reek:LongParameterList
  def build_comment(title, author, url, comments_count)
    "#{title} by #{author} - #{url} (#{comments_count} #{"comment".pluralize(comments_count)})"
  end

  def digest_unixtime
    digest_date.end_of_day.strftime("%Q")
  end

  def digest_date
    @digest_date ||= DateTime.parse(uid)
  end

  def max_posts_number
    feed_options["max_posts_number"] || DEFAULT_MAX_POSTS_NUMBER
  end
end
