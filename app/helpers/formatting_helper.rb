module FormattingHelper
  def ago(time)
    time ? "#{distance_of_time_in_words_to_now(time).gsub("about ", "")} ago" : ""
  end

  def format_feed_state(feed)
    state = feed.state

    tag.span(
      class: ["hint--top", feed_state_class(state)].join(" "),
      data: {hint: "errors since last success: #{feed.errors_count}; total errors: #{feed.total_errors_count}"}
    ) { state }
  end
end
