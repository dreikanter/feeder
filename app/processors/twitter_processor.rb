class TwitterProcessor < BaseProcessor
  protected

  def entities
    tweets.map { |tweet| entity(tweet.fetch('id').to_s, tweet) }
  end

  def tweets
    content.as_json
  end
end
