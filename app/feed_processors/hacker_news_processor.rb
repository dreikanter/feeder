module FeedProcessors
  class HackerNewsProcessor < FeedProcessors::Base
    BASE_URL = 'https://news.ycombinator.com'.freeze

    def entities
      [links, scores, threads].transpose.map do |link, score, thread|
        [link['href'], entity(link, score, thread)]
      end
    end

    def links
      html.css('.athing > .title > .storylink')
    end

    def scores
      html.css('.athing + tr .score')
    end

    def threads
      html.css('.athing + tr .age > a')
    end

    def html
      @html ||= Nokogiri::HTML(source)
    end

    def entity(link, score, thread)
      {
        text: link.text,
        url: link['href'],
        score: score.text,
        thread_url: "#{BASE_URL}/#{thread['href']}"
      }
    end
  end
end
