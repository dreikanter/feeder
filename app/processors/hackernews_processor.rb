class HackernewsProcessor < BaseProcessor
  SCORE_THRESHOLD = 300

  protected

  def entities
    above_score_threshold.map { |item| entity(item.fetch("id"), item) }
  end

  def above_score_threshold
    sorted_items.filter { |item| item.fetch("score") > SCORE_THRESHOLD }
  end

  def sorted_items
    content.sort_by { |item| item.fetch("time") }.reverse
  end
end
