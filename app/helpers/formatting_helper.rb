module FormattingHelper
  def ago(time)
    "#{distance_of_time_in_words_to_now(time).gsub('about ', '')} ago"
  end

  def format_feed_state(feed)
    tag.span(
      class: ['hint--top', feed_state_class(feed.state)].join(' '),
      data: { hint: "errors since last success: #{feed.errors_count}; total errors: #{feed.total_errors_count}" }
    ) { feed.state }
  end

  private

  def feed_state_class(state)
    case state
    when 'enabled'
      'text-success'
    when 'disabled'
      'text-muted'
    when 'removed'
      'text-muted'
    end
  end
end
