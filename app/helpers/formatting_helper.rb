module FormattingHelper
  def ago(time)
    time ? "#{distance_of_time_in_words_to_now(time).gsub("about ", "")} ago" : ""
  end

  def compact_ago(time)
    distance_of_time_in_words_to_now(time, compact: true, highest_measure_only: true)
  end

  def format_feed_state(feed)
    state = feed.state

    tag.span(
      class: feed_state_class(state),
      title: format_feed_title(feed),
      data: {bs_toggle: "tooltip", bs_placement: "top", bs_html: true}
    ) { state }
  end

  private

  def format_feed_title(feed)
    feed.disabled? ? feed.disabling_reason : ""
  end


  FEED_STATE_CLASSES = {
    "pristine" => "text-muted",
    "enabled" => "text-success",
    "paused" => "text-warning",
    "disabled" => "text-muted"
  }.freeze

  private_constant :FEED_STATE_CLASSES

  def feed_state_class(state)
    FEED_STATE_CLASSES[state]
  end
end
