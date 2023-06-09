class HackerNewsNormalizer < BaseNormalizer
  MIN_SCORE = 300

  protected

  def validation_errors
    [].tap do |errors|
      errors << 'insufficient score' if violates_score_threshold?
    end
  end

  def text
    [data['title'], data['url']].compact_blank.join(separator)
  end

  def link
    content[:link]
  end

  def comments
    [[score, link].compact_blank.join(' / ')]
  end

  def published_at
    Time.zone.at(data['time'])
  end

  private

  def score
    value = data['score'].to_i
    "#{value} #{'point'.pluralize(value)}"
  end

  def data
    @data ||= JSON.parse(RestClient.get(content[:data_url]).body)
  end

  def violates_score_threshold?
    data['score'].to_i <= MIN_SCORE
  end
end
