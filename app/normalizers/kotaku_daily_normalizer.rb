class KotakuDailyNormalizer < BaseNormalizer
  protected

  def text
    "Kotaku posts for #{digest_date.strftime('%d %b %Y')} - #{link}"
  end

  def link
    "https://kotaku.com/latest?startTime=#{digest_unixtime}"
  end

  def published_at
    digest_date
  end

  def attachments
    [content.first.fetch(:post).image].compact_blank
  end

  def comments
    content.map do |item|
      post = item.fetch(:post)
      build_comment(post.title.strip, post.author.strip, post.url.strip, item.fetch(:comments_count))
    end
  end

  def build_comment(title, author, url, comments_count)
    "#{title} by #{author} - #{url} (#{comments_count} #{"comment".pluralize(comments_count)})"
  end

  private

  def digest_unixtime
    digest_date.end_of_day.strftime("%Q")
  end

  def digest_date
    @digest_date ||= DateTime.parse(uid)
  end
end
