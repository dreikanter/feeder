class TwitterProcessor < BaseProcessor
  protected

  def entities
    tweets.map { |tweet| Entity.new(tweet.fetch('id').to_s, tweet) }
  end

  def tweets
    content.as_json
  end
end
