class LibredditContent
  POST_SCORE_SELECTOR = ".post_score".freeze
  POST_SCORE_ATTRIBUTE = "title".freeze

  # @return [String, nil] score of the first post found on a Libreddit page,
  #   or nil when the page carries none. A Libreddit instance that answers with
  #   an anti-bot challenge or an error page under a 2xx status yields nil,
  #   which lets callers treat it as broken.
  def self.post_score(content)
    Nokogiri::HTML(content.to_s).css(POST_SCORE_SELECTOR).attribute(POST_SCORE_ATTRIBUTE)&.value
  end

  # @return [Boolean] true when the content looks like a Libreddit post or
  #   listing page, i.e. it exposes a post score.
  def self.post_score?(content)
    post_score(content).present?
  end
end
