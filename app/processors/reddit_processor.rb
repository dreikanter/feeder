module Processors
  class RedditProcessor < Processors::AtomProcessor
    POINTS_THRESHOLD = 2000
    CACHE_HISTORY_DEPTH = 4.hours

    def entities
      super.lazy.select { |uid, _| enough_points?(uid) }
    end

    private

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
      Rails.logger.debug 'attempting to load reddit points from cache'
      DataPoint.for(:reddit).
        where('created_at > ?', CACHE_HISTORY_DEPTH.ago).
        where("details->>'link' = ?", link).ordered.first
    end

    # TODO: Use Reddit API instead
    def create_data_point(link)
      Rails.logger.debug 'loading reddit points from reddit'
      html = Nokogiri::HTML(page_content(link))
      desc = html.at('meta[property="og:description"]').try(:[], :content).to_s
      points = parse_points(desc)
      raise 'error loading reddit points' unless points
      DataPoint.create_reddit(link: link, points: points, description: desc)
    end

    def parse_points(string)
      Integer(string[/^[\d,]+/].gsub(',', ''))
    rescue
      nil
    end

    def page_content(link)
      safe_link = URI::encode(URI::decode(link))
      RestClient.get(safe_link).body
    end
  end
end
