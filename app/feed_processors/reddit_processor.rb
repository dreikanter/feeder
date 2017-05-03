module FeedProcessors
  class RedditProcessor < FeedProcessors::AtomProcessor
    POINTS_THRESHOLD = 2000

    def entities
      super.lazy.select { |entity| enough_points?(entity.first) }
    end

    protected

    def enough_points?(link)
      reddit_points(link) >= POINTS_THRESHOLD
    end

    def reddit_points(link)
      data_point(link).details['points'].to_i
    end

    def data_point(link)
      cached_data_point(link) || create_data_point(link)
    end

    def cached_data_point(link)
      Rails.logger.debug 'loading reddit points from cache'
      DataPoint.for(:reddit).
        where('created_at > ?', 6.hours.ago).
        where("details->>'link' = ?", link).ordered.first
    end

    def create_data_point(link)
      Rails.logger.debug 'loading reddit points from reddit'
      html = Nokogiri::HTML(page_content(link))
      points = html.at('.sitetable .score.unvoted')[:title].to_i
      desc = html.at('meta[property="og:description"]')[:content]
      DataPoint.create_reddit(link: link, points: points, description: desc)
    end

    def page_content(link)
      RestClient.get(link).body
    end

    def limit
      0
    end
  end
end
