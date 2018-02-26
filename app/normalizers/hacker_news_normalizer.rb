module Normalizers
  class HackerNewsNormalizer < Normalizers::Base
    MIN_SCORE = 300

    def valid?
      data['score'].to_i >= MIN_SCORE
    end

    def text
      [data['title'], data['url']].reject(&:blank?).join(separator)
    end

    def link
      entity[:link]
    end

    def comments
      [[score, link].reject(&:blank?).join(' / ')]
    end

    def score
      value = data['score'].to_i
      "#{value} #{'point'.pluralize(value)}"
    end

    def published_at
      Time.zone.at(data['time'])
    end

    def data
      @data ||= JSON.parse(RestClient.get(entity[:data_url]).body)
    end
  end
end
