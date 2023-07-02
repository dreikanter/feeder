class HackernewsProcessor < BaseProcessor
  SCORE_THRESHOLD = 300

  protected

  def entities
    above_score_threshold.map { build_entity(_1.fetch("id").to_s, _1) }
  end

  def above_score_threshold
    sorted_items.filter { _1.fetch("score") > SCORE_THRESHOLD }
  end

  def sorted_items
    content.sort_by { _1.fetch("time") }.reverse
  end
end
