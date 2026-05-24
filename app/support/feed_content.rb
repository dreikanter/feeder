class FeedContent
  # @return [Boolean] true when the content can be parsed as a feed. A Nitter
  #   instance that returns an HTML error or rate-limit page with a 2xx status
  #   fails this check, which lets callers treat it as unavailable.
  def self.parseable?(content)
    Feedjira.parse(content.to_s).entries
    true
  rescue StandardError
    false
  end
end
