module FormattingHelper
  def ago(time)
    time ? "#{distance_of_time_in_words_to_now(time).gsub('about ', '')} ago" : ''
  end

  def format_feed_state(feed)
    state = feed.state

    tag.span(
      class: ['hint--top', feed_state_class(state)].join(' '),
      data: { hint: "errors since last success: #{feed.errors_count}; total errors: #{feed.total_errors_count}" }
    ) { state }
  end

  private

  FEED_STATE_CLASSES = {
    'enabled' => 'text-success',
    'disabled' => 'text-muted',
    'removed' => 'text-muted'
  }.freeze

  private_constant :FEED_STATE_CLASSES

  def feed_state_class(state)
    FEED_STATE_CLASSES[state]
  end
end
