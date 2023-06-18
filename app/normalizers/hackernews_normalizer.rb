class HackernewsNormalizer < BaseNormalizer
  MIN_SCORE = 300

  protected

  def text
    [content["title"], content["url"]].compact_blank.join(separator)
  end

  def link
    Hackernews.thread_url(content["id"])
  end

  def comments
    [[annotated_score, link].compact_blank.join(" / ")]
  end

  def published_at
    Time.zone.at(content["time"])
  end

  private

  def annotated_score
    content["score"].then { |score| "#{score} #{"point".pluralize(score)}" }
  end
end
