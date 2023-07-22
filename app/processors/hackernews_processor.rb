class HackernewsProcessor < BaseProcessor
  SCORE_THRESHOLD = 300

  def entities
    above_score_threshold.map { build_entity(_1.fetch("id"), _1) }
  end

  private

  def above_score_threshold
    sorted_items.filter { _1.fetch("score") > SCORE_THRESHOLD }
  end

  def sorted_items
    content.sort_by { _1.fetch("time") }.reverse
  end
end
